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
      icon ""
      text interface
    end

    if `cat /sys/class/net/#{interface}/operstate`.strip == "down"
      icon ""
      text "#{interface} down"
      color :red
    end
  end

  def get_connections
    return `/usr/sbin/connmanctl services`.lines.map do |line|
      id = line.split(" ").last
      data = Hash[`/usr/sbin/connmanctl services #{id}`.lines.drop(1).map do |line|
        line.split(" = ").map { |s| s.strip }
      end]

      icon = case
            when ["online", "ready"].include?(data["State"])
              "object-select"
            when data["Type"] == "wifi"
              if data["Security"] != "[ none ]"
                "network-wireless-secure-signal-excellent"
              else
                "network-wireless-signal-excellent"
              end
            when data["Type"] == "ethernet"
              "network-wired"
            end

      {
        id: id,
        type: data["Type"],
        icon: icon,
        name: data["Name"].to_s.gsub("&", "&amp;"),
        strength: data["Strength"]
      }
    end
  end

  def select_connection(connections)
    headers = [
      "ID:HD", "Type:HD", ":IMG", "Name", "Strength:NUM"
    ].map { |s| "--column='#{s}'" }.join(" ")
    lines = connections.map { |h| h.values }.map { |srv| "'#{srv.join("' '")}'" }.join(" ")

    return `yad --list --height=200 --width=400 --title="Connman services" \
            #{headers} #{lines} --print-column=1 --separator=`.strip
  end

  on :mouse do |button|
    if button == 1
      id = select_connection(get_connections)

      `yad --height=200 --width=400 --borders=64 --title="Service ID" --text #{id} --no-buttons \
       --selectable-labels --text-align=center --timeout=5 --timeout-indicator=bottom`
    end
  end

  update(interface)
end
