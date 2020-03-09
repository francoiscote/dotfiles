-- Inspired by Linux alt-drag or Better Touch Tools move/resize functionality
-- https://gist.github.com/kizzx2/e542fa74b80b7563045a
local helpers = require("helpers")

local moveResize = {}

dragging_win = nil

drag_event = hs.eventtap.new({ 
    hs.eventtap.event.types.leftMouseDragged,
    hs.eventtap.event.types.rightMouseDragged, 
}, function(e)
  if not dragging_win then return nil end

  local dx = e:getProperty(hs.eventtap.event.properties.mouseEventDeltaX)
  local dy = e:getProperty(hs.eventtap.event.properties.mouseEventDeltaY)
  local mouse = hs.mouse:getButtons()

  if mouse.left then
    dragging_win:move({dx, dy}, nil, false, 0)
  elseif mouse.right then
    local sz = dragging_win:size()
    local w1 = sz.w + dx
    local h1 = sz.h + dy
    dragging_win:setSize(w1, h1)
  end
end)

moveResize.start = function()
  dragging_win = helpers.get_window_under_mouse()
  drag_event:start()
end

moveResize.stop = function()
  dragging_win = nil
  drag_event:stop()
end

return moveResize