-- Run from repo root: luajit hammerspoon/tests/twitch-focus.lua
-- Exercise the focus-mode section with mocked Hammerspoon dependencies.
local file = assert(io.open("hammerspoon/.hammerspoon/window-management/init.lua"))
local source = file:read("*a")
file:close()
local section = assert(source:match("local focusMode = false(.-)%-%- Move Windows"))
local enabled = false
local restored
local placement
local original = { x = 10, y = 20, w = 800, h = 600 }
local main = { x = 640, y = 0, w = 1280, h = 1080 }
local function app(name)
  return {
    name = function() return name end,
    hide = function(self) self.hidden = true end,
    unhide = function(self) self.hidden = false end,
  }
end
local focusedApp = app("Google Chrome")
local obs = app("OBS Studio")
local dashboard = app("Twitch - Dashboard")
local other = app("Ghostty")
local apps = { focusedApp, obs, dashboard, other }
local focusedWindow = {
  application = function() return focusedApp end,
  frame = function() return original end,
  setFrame = function(_, frame) restored = frame end,
}
local windows = {}
for _, application in ipairs(apps) do
  local current = application
  windows[#windows + 1] = { application = function() return current end }
end
local environment = setmetatable({
  hs = {
    menubar = { new = function() return { setTitle = function() end } end },
    styledtext = { new = function(text) return text end },
    application = { runningApplications = function() return apps end },
    window = {
      focusedWindow = function() return focusedWindow end,
      filter = { new = function() return {
        setCurrentSpace = function(self) return self end,
        getWindows = function() return windows end,
      } end },
    },
  },
  twitchMode = { isEnabled = function() return enabled end },
  layouts = { twitchAreas = { main = main } },
  areas = { custom = { large = "large", small = "small", medium = "medium" } },
  grid = { setWindowToCell = function(window, cell, area)
    placement = { window = window, cell = cell, area = area }
  end },
  helpers = { unhideAllApps = function()
    for _, application in ipairs(apps) do application:unhide() end
  end },
}, { __index = _G })
local chunk = assert(loadstring("local focusMode = false" .. section .. "\nreturn toggleFocusMode"))
setfenv(chunk, environment)
local toggle = chunk()

for _, case in ipairs({ { "Google Chrome", "large" }, { "Finder", "small" }, { "Zed", "medium" } }) do
  enabled = true
  focusedApp.name = function() return case[1] end
  obs.hidden, dashboard.hidden = true, true
  toggle()
  assert(placement.window == focusedWindow and placement.cell == "large" and placement.area == main)
  assert(not obs.hidden and not dashboard.hidden and other.hidden)
  toggle()
  assert(restored == original and not other.hidden)
end

enabled = false
toggle()
assert(placement.area == nil and placement.cell == "medium")
assert(not obs.hidden and not dashboard.hidden)
toggle()
assert(restored == original)
print("PASS: Twitch focus proportions, OBS/dashboard visibility, frame restoration, normal focus")
