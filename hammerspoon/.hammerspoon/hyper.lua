local modal = hs.hotkey.modal.new({}, "F17")

-- Enter Hyper Modal when HyperKey is pressed
local pressHyper = function()
  modal.triggered = false
  modal:enter()
end

-- Leave Hyper Modal when Hyper key is pressed,
--   send ESCAPE if no other keys are pressed.
local releaseHyper = function()
  modal:exit()
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