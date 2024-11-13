local grid = require("window-management/grid")

local twitchMode = {}

local state = {
  active = false
}

local TwitchMenuBar = hs.menubar.new()

function twitchMode.set(newState)
  state.active = newState;
  if state.active then
    -- grid.setNoMargins();
    TwitchMenuBar:setTitle(hs.styledtext.new("TWITCH",
      { backgroundColor = { red = 1, blue = 0, green = 0 }, color = { red = 1, blue = 1, green = 1 } }))
  else
    -- grid.setDefaultMargins();
    TwitchMenuBar:setTitle();
  end
end

function twitchMode.isActive()
  return state.active
end

return twitchMode
