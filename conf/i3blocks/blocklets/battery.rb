Blocklet.new do
  def upower(device)
    output = `upower -i $(upower -e | grep #{device})`
    return nil if output.empty?

    Hash[output.each_line.collect do |line|
      kv = line.split(":", 2)
      next if kv.count != 2
      kv[0].strip!.gsub!(/[ -]/, "_")
      kv[1].strip!
      kv
    end.compact!]
  end

  battery = upower("BAT")
  ac_adapter = upower("ACAD")

  if battery.nil?
    icon ""
    text "No battery"
  else
    case battery["percentage"].gsub(/%/, "").to_f
    when 95.0..100.0
      icon ""
    when 75.0...95.0
      icon ""
    when 50.0...75.0
      icon ""
    when 25.0...50.0
      icon ""
      color :yellow
    when 0.0...25.0
      icon ""
      color :red
    end

    case battery["state"]
    when "fully-charged"
      text battery["percentage"]
    when "charging"
      icon ""
      text battery["time_to_full"]
      color :normal
    when "discharging"
      text battery["time_to_empty"]
    end
  end

  if !ac_adapter.nil? and ac_adapter["online"] == "yes"
    icon ""
  end
end
