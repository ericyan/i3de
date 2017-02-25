Blocklet.new do
  interface = (/dev (\S+)/ =~ `ip route | grep default | head -n 1`).nil? ? "" : $~[1]
  abort "No interface available" if interface.empty?

  stats_file = "/dev/shm/#{interface}_statistics"
  stats_last = Marshal.load(File.open(stats_file, "rb")) if File.exist? stats_file

  stats_current = {
    time: Time.now,
    rx_bytes: `cat /sys/class/net/#{interface}/statistics/rx_bytes`.to_i,
    tx_bytes: `cat /sys/class/net/#{interface}/statistics/tx_bytes`.to_i
  }

  File.open(stats_file, "wb") do |f|
    f.write Marshal.dump(stats_current)
    f.close
  end

  # Ignore outdated data
  stats_last = nil if !stats_last.nil? and stats_current[:time] - stats_last[:time] > 60

  if stats_last.nil?
    direction = "rx"
    bandwidth_value = 0.0
    bandwidth_unit = "Kbps"
  else
    rx_bits = (stats_current[:rx_bytes] - stats_last[:rx_bytes]) * 8
    tx_bits = (stats_current[:tx_bytes] - stats_last[:tx_bytes]) * 8
    time_window = stats_current[:time] - stats_last[:time]

    direction = rx_bits > tx_bits ? "rx" : "tx"
    bandwidth_value = (rx_bits > tx_bits ? rx_bits : tx_bits) / 1000.0 / time_window
    bandwidth_unit = "Kbps"
  end

  if bandwidth_value > 1000 and bandwidth_unit == "Kbps"
    bandwidth_value = (bandwidth_value / 1000).round(2)
    bandwidth_unit = "Mbps"
  end

  icon direction == "rx" ? "" : ""
  text "#{bandwidth_value.round(1)} #{bandwidth_unit}"
end
