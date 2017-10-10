Blocklet.new do
  ip = (/src (\S+)/ =~ `ip route get 192.168.0.1 | head -n 1`).nil? ? "" : $~[1]

  icon ''
  text ip
end
