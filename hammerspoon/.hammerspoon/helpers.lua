local helpers = {}

function helpers.isZoomRunning()
  return hs.application.get('zoom.us')
end

function helpers.logWindowInfo(w)
  log.d("Id:", w:id())
  log.d("Title:", w:title())
  log.d("Size:", w:size())
  log.d("Frame:", w:frame())
  log.d("Role:", w:role())
  log.d("Subrole:", w:subrole())
end

function helpers.setWindowsToCell(winFilter, grid, cell)
  local wins = winFilter:getWindows()
  for i,w in pairs(wins) do
    grid.set(w, cell)
  end
end

function helpers.getDynamicMargins(h, v)
  local max = hs.window.focusedWindow():screen():frame()
  local hPad = math.floor(max.w * h)
  local vPad = math.floor(max.h * v)

  return hs.geometry.size(hPad,vPad)
end

function helpers.get_window_under_mouse()
  -- Invoke `hs.application` because `hs.window.orderedWindows()` doesn't do it
  -- and breaks itself
  local _ = hs.application

  local my_pos = hs.geometry.new(hs.mouse.getAbsolutePosition())
  local my_screen = hs.mouse.getCurrentScreen()

  return hs.fnutils.find(hs.window.orderedWindows(), function(w)
    return my_screen == w:screen() and my_pos:inside(w:frame())
  end)
end

return helpers