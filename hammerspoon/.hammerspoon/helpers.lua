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
  log.d(w)
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

return helpers