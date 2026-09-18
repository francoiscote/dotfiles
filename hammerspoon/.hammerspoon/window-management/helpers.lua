local export = {}
local unpackValues = table.unpack or unpack

local function pack(...)
  return { n = select("#", ...), ... }
end

-- HELPER FUNCTIONS
-------------------------------------------------------------------------------
function export.unhideAllApps()
  for _, app in ipairs(hs.application.runningApplications()) do
    app:unhide()
  end
end

function export.maximiseWindows(windows)
  for _, window in ipairs(windows) do
    window:maximize()
  end
end

function export.maximiseFilteredWindows(windowFilter)
  export.maximiseWindows(windowFilter:getWindows())
end

function export.getDynamicMargins(horizontal, vertical, screen)
  local frame = (screen or hs.screen.primaryScreen()):frame()
  local horizontalPadding = math.floor(frame.w * horizontal)
  local verticalPadding = math.floor(frame.h * vertical)

  return hs.geometry.size(horizontalPadding, verticalPadding)
end

-- Workaround for Chrome windows animated by AXEnhancedUserInterface.
-- https://github.com/Hammerspoon/hammerspoon/issues/3224#issuecomment-1294971600
function export.axHotfix(window)
  window = window or hs.window.frontmostWindow()
  local app = window and window:application()
  local axApp = app and hs.axuielement.applicationElement(app)

  if not axApp then
    return function() end
  end

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
  position = position or 1

  return function(...)
    local args = pack(...)
    local revert = export.axHotfix(args[position])
    local results = pack(xpcall(function()
      return fn(unpackValues(args, 1, args.n))
    end, debug.traceback))

    revert()

    if not results[1] then
      error(results[2], 0)
    end

    return unpackValues(results, 2, results.n)
  end
end

return export
