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
local filters = {}
local focused
local gridCalls = 0
local marginCalls = 0
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
      local window = {
        screen = function() return screen end,
        setFrame = function(self, frame, duration)
          assert(duration == 0)
          self.frame = frame
        end,
      }
      local foreign = {
        screen = function() return { id = function() return 2 end } end,
        setFrame = function() error("Moved foreign-screen window") end,
      }
      local filter = {
        setCurrentSpace = function(self) return self end,
        setScreens = function() end,
        getWindows = function() return { window } end,
        window = window,
        foreign = foreign,
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

local function assertArea(window, area)
  local frame = assert(window.frame)
  assert(frame.x == -1920 + area.x and frame.y == 25 + area.y)
  assert(frame.w == area.w and frame.h == area.h)
end

enabled = true
for _, layout in ipairs({ layouts.workBrowse, layouts.workCode, layouts.workEven, layouts.workMax }) do
  for _, shifted in ipairs({ false, true }) do
    layout(shifted)
    assertArea(filters[6].window, layouts.twitchAreas.secondaryBottom)
    assertArea(filters[7].window, layouts.twitchAreas.secondaryRight)
    for i = 1, 5 do
      local frame = filters[i].window.frame
      assert(frame.x >= -1920 + main.x and frame.y >= 25 + main.y)
      assert(frame.x + frame.w <= -1920 + main.x + main.w + 0.000001)
      assert(frame.y + frame.h <= 25 + main.y + main.h + 0.000001)
    end
  end
end
assert(gridCalls == 0 and marginCalls == marginsBefore)
layouts.workBrowse()
assert(filters[1].window.frame.w == main.w * 8 / 12)
assert(filters[3].window.frame.w == main.w * 4 / 12)
layouts.workMax()
for i = 1, 5 do assertArea(filters[i].window, main) end

-- Manual overrides also work for OBS/dashboard.
for _, index in ipairs({ 1, 6, 7 }) do
  focused = filters[index].window
  assert(grid.setFocusedWindowToCell("0,0 12x12"))
  assertArea(focused, main)
  assert(grid.setFocusedWindowToCell("2.5,1.5 7x9"))
  assert(focused.frame.w == main.w * 7 / 12)
end
assert(not grid.setWindowToCell(filters[1].foreign, "0,0 12x12", main))

enabled = false
layouts.workBrowse()
assert(gridCalls == 6)
layouts.workMax()
for i = 1, 5 do assert(filters[i].window.maximized) end
assert(grid.setFocusedWindowToCell("0,0 12x12"))
assert(gridCalls == 7)
assert(loadfile("hammerspoon/.hammerspoon/window-management/init.lua"))
print("PASS: Twitch layouts, shifted variants, pinned zones, no margins, manual overrides, screen guard, normal mode")
