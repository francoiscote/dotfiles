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
  local max = hs.screen.mainScreen():frame()
  local hPad = math.floor(max.w * h)
  local vPad = math.floor(max.h * v)

  return hs.geometry.size(hPad, vPad)
end

-- Workaround fix for the Grammarly bug that causes the window to be animated
-- https://github.com/Hammerspoon/hammerspoon/issues/3224#issuecomment-1294971600
local function axHotfix(win)
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
