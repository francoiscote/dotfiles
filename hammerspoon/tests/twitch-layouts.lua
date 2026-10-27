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
  frame = function() return { x = -1920, y = 25 } end,
}
local filters, focused = {}, nil
local gridCalls, marginCalls = 0, 0
local function window(x, title, windowScreen)
  return {
    currentFrame = { x = x or 0, y = 0, w = 100, h = 100 },
    screen = function() return windowScreen or screen end,
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
local obs, projector = window(0, "OBS 33.0.0 - Profile"), window(0, "Projector - Preview")
local left, right = window(-1900), window(650)
local foreign = window(0, "OBS 33.0.0", { id = function() return 2 end })
filters[8].windows = { obs, projector, foreign }
filters[9].windows = { right, left }

local function assertArea(w, area)
  local frame = w.currentFrame
  assert(frame.x == -1920 + area.x and frame.y == 25 + area.y)
  assert(frame.w == area.w and frame.h == area.h)
end

enabled = true
for _, layout in ipairs({ layouts.workVideo, layouts.workCode, layouts.workEven, layouts.workMax }) do
  for _, shifted in ipairs({ false, true }) do
    layout(shifted)
    assertArea(obs, layouts.twitchAreas.secondaryBottom)
    assertArea(left, layouts.twitchAreas.secondaryLeft)
    assertArea(right, layouts.twitchAreas.secondaryRight)
    assert(projector.currentFrame.w == 100 and foreign.currentFrame.w == 100)
    for i = 1, 7 do
      local frame = filters[i].windows[1].currentFrame
      assert(frame.x >= -1920 + main.x and frame.y >= 25 + main.y)
      assert(frame.x + frame.w <= -1920 + main.x + main.w + 0.000001)
      assert(frame.y + frame.h <= 25 + main.y + main.h + 0.000001)
    end
  end
end
assert(gridCalls == 0 and marginCalls == marginsBefore)
layouts.workMax()
for i = 1, 7 do assertArea(filters[i].windows[1], main) end
filters[9].windows = { right }
layouts.twitch()
assertArea(right, layouts.twitchAreas.secondaryRight)
filters[9].windows = { left }
layouts.twitch()
assertArea(left, layouts.twitchAreas.secondaryLeft)
focused = obs
assert(grid.setFocusedWindowToCell("0,0 12x12"))
assertArea(obs, main)
assert(not grid.setWindowToCell(foreign, "0,0 12x12", main))
enabled = false
layouts.workMax()
for i = 1, 7 do assert(filters[i].windows[1].maximized) end
assert(grid.setFocusedWindowToCell("0,0 12x12"))
assert(gridCalls == 1)
print("PASS: Twitch layouts, dashboard columns, OBS filtering, screen guard, normal mode")
