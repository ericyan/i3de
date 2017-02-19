Blocklet.new do
  interface = `ip route | awk -v FS='(dev |  )' '/^default/ { print $2; exit }'`.strip
  if interface.empty?
    icon ""
    text "No network"
    color :red
  else
    is_wireless = /^wlan\d+/ === interface
    is_down = `cat /sys/class/net/#{interface}/operstate`.strip == "down"

    if is_wireless
      quality = `grep #{interface} /proc/net/wireless | awk '{ print $3 * 100 / 70 }'`.to_i

      icon ""
      text "#{quality}%"
      case quality
      when 60.0...80.0
        color :yellow
      when 0.0...60.0
        color :red
      end
    else
      icon ""
      text interface
    end

    if is_down
      icon ""
      text "#{interface} down"
      color :red
    end
  end
end
