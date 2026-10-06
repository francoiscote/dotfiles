local export = {}
local enabled = false
local menuBar = hs.menubar.new()

function export.isEnabled()
  return enabled
end

function export.toggle()
  enabled = not enabled

  if enabled then
    menuBar:setTitle(hs.styledtext.new("TWITCH", {
      backgroundColor = { red = 0.569, green = 0.275, blue = 1 },
      color = { red = 1, green = 1, blue = 1 },
    }))
    hs.application.launchOrFocus("OBS")
    hs.application.launchOrFocus("Twitch - Dashboard")
  else
    menuBar:setTitle()
  end
end

return export
