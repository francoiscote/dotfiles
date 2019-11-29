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

return helpers