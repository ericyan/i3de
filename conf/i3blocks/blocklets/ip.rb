Blocklet.new do
  icon ''
  text `ip route get 192.168.0.1 | awk '{print $NF;exit}'`
end
