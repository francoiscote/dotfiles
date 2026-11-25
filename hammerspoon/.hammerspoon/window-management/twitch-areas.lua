local export = {}

function export.forScreen(screen)
  local frame = screen:frame()
  local sidebarWidth = math.floor(frame.w * 0.325 + 0.5)
  local topHeight = math.floor(frame.h / 2)
  return {
    main = { x = sidebarWidth, y = 0, w = frame.w - sidebarWidth, h = frame.h },
    obs = { x = 0, y = 0, w = sidebarWidth, h = topHeight },
    obsidian = { x = 0, y = topHeight, w = sidebarWidth, h = frame.h - topHeight },
  }
end

function export.isPinned(window)
  local app = window and window:application()
  local name = app and app:name()
  return name == "Obsidian" or (name == "OBS Studio" and window:title():match("^OBS[%s%-]") ~= nil)
end

return export
