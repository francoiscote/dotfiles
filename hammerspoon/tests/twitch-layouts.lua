-- Run from repo root: luajit hammerspoon/tests/twitch-layouts.lua
package.path = "hammerspoon/.hammerspoon/?.lua;" .. package.path

local enabled = false
package.loaded["twitch-mode"] = { isEnabled = function() return enabled end }
package.loaded["window-management/helpers"] = {
  withAxHotfix = function(fn) return fn end,
  getDynamicMargins = function() return {} end,
  maximiseFilteredWindows = function(filter)
    for _, window in ipairs(filter:getWindows()) do window.maximized = true end
  end,
}

local screen = {
  id = function() return 1 end,
  name = function() return "primary" end,
  frame = function() return { x = -1920, y = 25, w = 2880, h = 1589 } end,
}
local filters, focused = {}, nil
local gridCalls, marginCalls = 0, 0
local function window(x, title, windowScreen, appName)
  return {
    currentFrame = { x = x or 0, y = 0, w = 100, h = 100 },
    screen = function() return windowScreen or screen end,
    application = function() return { name = function() return appName or "Generic" end } end,
    title = function() return title or "window" end,
    frame = function(self) return self.currentFrame end,
    setFrame = function(self, frame, duration)
      assert(duration == 0)
      self.currentFrame = frame
    end,
  }
end
hs = {
  screen = { primaryScreen = function() return screen end },
  geometry = { rect = function(x, y, w, h) return { x = x, y = y, w = w, h = h } end },
  menubar = { new = function() return { setTitle = function() end } end },
  grid = {
    set = function() gridCalls = gridCalls + 1 end,
    setGrid = function() end,
    setMargins = function() marginCalls = marginCalls + 1 end,
  },
  window = {
    focusedWindow = function() return focused end,
    filter = { new = function()
      local filter = {
        windows = { window() },
        setCurrentSpace = function(self) return self end,
        setScreens = function() end,
        getWindows = function(self) return self.windows end,
      }
      filters[#filters + 1] = filter
      return filter
    end },
  },
}

local grid = require("window-management/grid")
local layouts = require("window-management/layouts")
grid.build(screen)
layouts.build(screen)
local marginsBefore = marginCalls
local main = layouts.twitchAreas.main
assert(main.x == 936 and main.w == 1944 and main.h == 1589)
local obs = window(0, "OBS 33.0.0 - Profile", nil, "OBS Studio")
local projector = window(0, "Projector - Preview", nil, "OBS Studio")
local obsidian = window(0, "Notes", nil, "Obsidian")
local otherScreen = { id = function() return 2 end }
local foreign = window(0, "OBS 33.0.0", otherScreen, "OBS Studio")
local foreignNotes = window(0, "Notes", otherScreen, "Obsidian")
filters[9].windows = { obs, projector, foreign }
filters[10].windows = { obsidian, foreignNotes }
filters[7].windows[2] = obsidian

local function assertArea(w, area)
  local frame = w.currentFrame
  assert(frame.x == -1920 + area.x and frame.y == 25 + area.y)
  assert(frame.w == area.w and frame.h == area.h)
end

enabled = true
for _, layout in ipairs({ layouts.workVideo, layouts.workCode, layouts.workEven, layouts.workMax }) do
  for _, shifted in ipairs({ false, true }) do
    layout(shifted)
    assertArea(obs, layouts.twitchAreas.obs)
    assertArea(obsidian, layouts.twitchAreas.obsidian)
    assert(projector.currentFrame.w == 100 and foreign.currentFrame.w == 100 and foreignNotes.currentFrame.w == 100)
    for i = 1, 8 do
      local frame = filters[i].windows[1].currentFrame
      assert(frame.x >= -1920 + main.x and frame.y >= 25 + main.y)
      assert(frame.x + frame.w <= -1920 + main.x + main.w + 0.000001)
      assert(frame.y + frame.h <= 25 + main.y + main.h + 0.000001)
    end
  end
end
assert(gridCalls == 0 and marginCalls == marginsBefore)
layouts.workMax()
for i = 1, 8 do assertArea(filters[i].windows[1], main) end
for _, pinned in ipairs({ obs, obsidian }) do
  focused = pinned
  assert(not grid.setFocusedWindowToCell("0,0 12x12"))
end
assertArea(obs, layouts.twitchAreas.obs)
assertArea(obsidian, layouts.twitchAreas.obsidian)
focused = filters[1].windows[1]
assert(grid.setFocusedWindowToCell("0,0 12x12"))
assertArea(focused, main)
local newBrowser = window()
assert(grid.setWindowToCell(newBrowser, "0,0 12x12"))
assertArea(newBrowser, main)
assert(not grid.setWindowToCell(foreign, "0,0 12x12", main))
enabled = false
layouts.workMax()
for _, i in ipairs({ 2, 3, 6, 8 }) do assert(filters[i].windows[1].maximized) end
local callsBefore = gridCalls
assert(grid.setFocusedWindowToCell("0,0 12x12"))
assert(gridCalls == callsBefore + 1)
local resized = require("window-management/twitch-areas").forScreen({
  frame = function() return { w = 2560, h = 1409 } end,
})
assert(resized.main.x == 832 and resized.main.w == 1728 and resized.main.h == 1409)
assert(resized.obs.h + resized.obsidian.h == resized.main.h)
assert(resized.obsidian.y == resized.obs.h)
print("PASS: Twitch layouts, OBS/Obsidian pinning, screen guard, resolution scaling, normal mode")

local launches, pins = {}, 0
hs.application = { launchOrFocus = function(name) launches[#launches + 1] = name end }
hs.styledtext = { new = function(text) return text end }
layouts.twitch = function() pins = pins + 1 end
package.loaded["twitch-mode"] = nil
local twitchMode = require("twitch-mode")
twitchMode.toggle()
assert(twitchMode.isEnabled() and launches[1] == "OBS" and launches[2] == "Obsidian")
assert(#launches == 2 and pins == 1)
twitchMode.toggle()
assert(not twitchMode.isEnabled() and #launches == 2 and pins == 1)
print("PASS: Twitch startup launches OBS/Obsidian and applies sidebar")
