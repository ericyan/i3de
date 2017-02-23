Blocklet.new do
  interface = (/dev (\S+)/ =~ `ip route | grep default | head -n 1`).nil? ? "" : $~[1]

  if interface.empty?
    icon ""
    text "No network"
    color :red
  else
    is_wireless = /^wlan\d+/ === interface
    is_down = `cat /sys/class/net/#{interface}/operstate`.strip == "down"

    if is_wireless
      ssid = `/sbin/iwgetid --raw`.strip
      quality = `grep #{interface} /proc/net/wireless | awk '{ print $3 * 100 / 70 }'`.to_i

      icon ""
      text "#{ssid} (#{quality}%)"
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
