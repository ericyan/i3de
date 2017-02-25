Blocklet.new do
  icon nil
  text `date "+%a %I:%M%P"`

  on :mouse do |button, x, y|
    case button
    when 1
      `sensible-browser https://time.is/`
    when 3
      `yad --calendar --mouse --posy=24 --undecorated --no-buttons --close-on-unfocus`
    end
  end
end
