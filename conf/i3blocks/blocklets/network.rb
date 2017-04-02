Blocklet.new do
  interface = (/dev (\S+)/ =~ `ip route | grep default | head -n 1`).nil? ? "" : $~[1]

  def update(interface)
    case
    when interface.start_with?("wlan")
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
    when interface.start_with?("tun", "tap")
      icon ""
      text "VPN (#{interface})"
      color :green
    when interface.empty?
      icon ""
      text "No network"
      color :red
    else
      icon ""
      text interface
    end

    if `cat /sys/class/net/#{interface}/operstate`.strip == "down"
      icon ""
      text "#{interface} down"
      color :red
    end
  end

  on :mouse do |button|
    if button == 1
      `cmst --disable-tray-icon --counter-update-rate 300`
    end
  end

  update(interface)
end
