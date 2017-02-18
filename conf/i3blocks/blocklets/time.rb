Blocklet.new do
  icon nil
  text `date "+%a %I:%M%P"`

  on :mouse do |button, x, y|
    if button == 1
      `sensible-browser https://time.is/`
    end
  end
end
