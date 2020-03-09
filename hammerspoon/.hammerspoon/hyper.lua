local modal = hs.hotkey.modal.new({}, "F17")
local moveResize = require("moveResize")

-- Enter Hyper Modal when HyperKey is pressed
local pressHyper = function()
  modal.triggered = false
  modal:enter()

  moveResize.start()
end

-- Leave Hyper Modal when Hyper key is pressed,
--   send ESCAPE if no other keys are pressed.
local releaseHyper = function()
  modal:exit()
  moveResize.stop()
  if not modal.triggered then
    hs.eventtap.keyStroke({}, 'ESCAPE')
  end
end

local function hyperConstructor(key)
  -- Bind the Hyper key
  hs.hotkey.bind({}, key, pressHyper, releaseHyper)
  return modal
end

return hyperConstructor