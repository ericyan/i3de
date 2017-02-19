Blocklet.new do
  loadavg =`cut -d ' ' -f1 /proc/loadavg`.to_f
  nproc = `nproc`.to_i

  icon ""
  text loadavg
  color :yellow if loadavg / nproc > 0.8
  color :red  if loadavg / nproc > 1.0
end
