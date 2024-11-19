local export = {}
local spaces = hs.spaces
local window = require "hs.window"

-- HELPER FUNCTIONS
-------------------------------------------------------------------------------
function export.unhideAllApps()
  local apps = hs.application.runningApplications()
  for i, app in pairs(apps) do
    app:unhide()
  end
end

function export.maximiseWindows(windows)
  for i, w in pairs(windows) do
    w:maximize()
  end
end

function export.maximiseFilteredWindows(wf)
  local windows = wf:getWindows()
  export.maximiseWindows(windows)
end

function export.getDynamicMargins(h, v)
  local max = hs.window.focusedWindow():screen():frame()
  local hPad = math.floor(max.w * h)
  local vPad = math.floor(max.h * v)

  return hs.geometry.size(hPad, vPad)
end

function getGoodFocusedWindow(nofull)
  local win = window.focusedWindow()
  if not win or not win:isStandard() then return end
  if nofull and win:isFullScreen() then return end
  return win
end

function flashScreen(screen)
  local flash = hs.canvas.new(screen:fullFrame()):appendElements({
    action = "fill",
    fillColor = { alpha = 0.25, red = 1 },
    type = "rectangle"
  })
  flash:show()
  hs.timer.doAfter(.15, function() flash:delete() end)
end

function switchSpace(skip, dir)
  for i = 1, skip do
    hs.eventtap.keyStroke({ "cmd", "alt", "ctrl", "fn" }, dir, 0) -- "fn" is a bugfix!
  end
end

function export.moveWindowOneSpace(dir, switch)
  local win = getGoodFocusedWindow(true)
  if not win then return end
  local screen = win:screen()
  local uuid = screen:getUUID()
  local userSpaces = nil
  for k, v in pairs(spaces.allSpaces()) do
    userSpaces = v
    if k == uuid then break end
  end
  if not userSpaces then return end

  for i, spc in ipairs(userSpaces) do
    if spaces.spaceType(spc) ~= "user" then -- skippable space
      table.remove(userSpaces, i)
    end
  end
  if not userSpaces then return end

  local initialSpace = spaces.windowSpaces(win)
  if not initialSpace then return else initialSpace = initialSpace[1] end
  local currentCursor = hs.mouse.getRelativePosition()

  if (dir == "right" and initialSpace == userSpaces[#userSpaces]) or
      (dir == "left" and initialSpace == userSpaces[1]) then
    flashScreen(screen) -- End of Valid Spaces
  else
    local zoomPoint = hs.geometry(win:zoomButtonRect())
    local safePoint = zoomPoint:move({ -1, -1 }).topleft
    hs.eventtap.event.newMouseEvent(hs.eventtap.event.types.leftMouseDown, safePoint):post()
    switchSpace(1, dir)
    hs.timer.waitUntil(
      function() return spaces.windowSpaces(win)[1] ~= initialSpace end,
      function()
        hs.eventtap.event.newMouseEvent(hs.eventtap.event.types.leftMouseUp, safePoint):post()
        hs.mouse.setRelativePosition(currentCursor)
      end, 0.05)
  end
end

-- Workaround fix for the Grammarly bug that causes the window to be animated
-- https://github.com/Hammerspoon/hammerspoon/issues/3224#issuecomment-1294971600
function axHotfix(win)
  if not win then win = hs.window.frontmostWindow() end

  local axApp = hs.axuielement.applicationElement(win:application())
  local wasEnhanced = axApp.AXEnhancedUserInterface
  if wasEnhanced then
    axApp.AXEnhancedUserInterface = false
  end

  return function()
    if wasEnhanced then
      axApp.AXEnhancedUserInterface = true
    end
  end
end

function export.withAxHotfix(fn, position)
  if not position then position = 1 end
  return function(...)
    local args = { ... }
    local revert = axHotfix(args[position])
    fn(...)
    revert()
  end
end

return export
