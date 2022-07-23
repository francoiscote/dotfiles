local helpers = {}

function helpers.logWindowInfo(w)
  log.d("Application Name:", w:application():name())
  log.d("Id:", w:id())
  log.d("Title:", w:title())
  log.d("TopLeft:", w:topLeft())
  log.d("Size:", w:size())
  log.d("isFullScreen:", w:isFullScreen())
  log.d("Frame:", w:frame())
  log.d("Role:", w:role())
  log.d("Subrole:", w:subrole())
  log.d(w)
end

function helpers.setWindowsToCell(wf, grid, cell)
  local wins = wf:getWindows()
  log.d("test", wins, grid, cell)
  for i,w in pairs(wins) do
    grid.set(w, cell)
  end
end

function helpers.maximiseAll(wf)
  local wins = wf:getWindows()
  for i,w in pairs(wins) do
    w:maximize()
  end
end

function helpers.getDynamicMargins(h, v)
  local max = hs.window.focusedWindow():screen():frame()
  local hPad = math.floor(max.w * h)
  local vPad = math.floor(max.h * v)

  return hs.geometry.size(hPad,vPad)
end

return helpers
