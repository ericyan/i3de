Blocklet.new do
  @control = instance || "Master"

  def is_output?
    type = @control == "Mic" ? :input : :output
    return type == :output
  end

  def get_card_id
    begin
      File.open(File.expand_path("~/.asoundrc"), "r").each_line do |line|
        return $~[1].to_i unless (/card\s+(\d)/ =~ line) == nil
      end
    rescue
      # Do nothing
    end

    return 0
  end

  def parse(data)
    volume, is_muted = nil, nil
    data.scan(/\[(\S+)\]/).flatten.each do |s|
      break unless  volume.nil? or is_muted.nil?

      if s.end_with? "%"
        volume = s.sub(/%/, "").to_i
        next
      end

      is_muted = false if s == "on"
      is_muted = true if s == "off"
    end

    return volume, is_muted
  end

  def update(volume, is_muted)
    if is_muted
      icon is_output? ? "" : ""
      text "Muted"
      color :yellow
    else
      icon is_output? ? "" : ""
      text "#{volume}%"
      color :normal
    end
  end

  on :mouse do |button|
    if button == 3
      `pavucontrol -t #{is_output? ? 1 : 2}`
    end

    result = case button
             when 1 then `amixer set #{@control} -c #{get_card_id} toggle`
             when 4 then `amixer set #{@control} -c #{get_card_id} 5%+ unmute`
             when 5 then `amixer set #{@control} -c #{get_card_id} 5%- unmute`
             end

    volume, is_muted = parse(result)
    update(volume, is_muted)
  end

  volume, is_muted = parse(`amixer get #{@control} -c #{get_card_id}`)
  update(volume, is_muted)
end
