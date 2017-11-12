Blocklet.new do
  @type = instance || "sink"
  @id = nil

  def is_output?
    return @type.downcase.to_sym == :sink
  end

  def type
    return is_output? ? :sink : :source
  end

  def id
    update! if @id.nil?
    return @id
  end

  def update!
    results = `pacmd list-#{type}s`.split("\n")

    id, volume, is_muted = nil
    results.each do |line|
      if id.nil?
        if line.start_with? "  * index: "
          id = line.delete_prefix("  * index: ").to_i
        end
      else
        if volume.nil? and line.start_with? "\tvolume: "
          data = line.delete_prefix("\tvolume: ").split(",").shift.split(":")[1]
          volume = data.split("/")[1].sub(/%/, "").to_i
        end

        if is_muted.nil? and line.start_with? "\tmuted: "
          is_muted = line.delete_prefix("\tmuted: ").strip == "yes"
        end

        break if !volume.nil? and !is_muted.nil?
      end
    end

    @id = id

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
    case button
    when 1 then `pactl set-#{type}-mute #{id} toggle`
    when 3 then `pavucontrol -t #{is_output? ? 1 : 2}`
    when 4 then `pactl set-#{type}-mute #{id} false && pactl set-#{type}-volume #{id} +5%`
    when 5 then `pactl set-#{type}-mute #{id} false && pactl set-#{type}-volume #{id} -5%`
    end

    update!
  end

  update!
end
