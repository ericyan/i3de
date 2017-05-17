Blocklet.new do
  control = instance || "Master"
  type = control == "Mic" ? :input : :output

  def parse(data)
    matched = data.match(/\[(\S+)\] \[(\S+)\]/)
    return matched[1].sub(/%/, "").to_i, matched[2] == "off"
  end

  def update(type, volume, is_muted)
    if is_muted
      if type == :output
        icon ""
      else
        icon ""
      end
      text "Muted"
      color :yellow
    else
      if type == :output
        icon ""
      else
        icon ""
      end
      text "#{volume}%"
      color :normal
    end
  end

  on :mouse do |button|
    result = case button
             when 1 then `amixer set #{control} toggle`
             when 4 then `amixer set #{control} 5%+ unmute`
             when 5 then `amixer set #{control} 5%- unmute`
             end

    volume, is_muted = parse(result)
    update(type, volume, is_muted)
  end

  volume, is_muted = parse(`amixer get #{control}`)
  update(type, volume, is_muted)
end
