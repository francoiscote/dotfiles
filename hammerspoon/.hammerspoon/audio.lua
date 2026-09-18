local hyper = spoon.Hyper

local primaryOutputs = {
  "Vanatoo T0",
  "Studio Display Speakers",
}

local secondaryOutputs = {
  "François’s AirPods Pro",
  "External Headphones",
  "MacBook Pro Speakers",
}

local function findFirstAvailable(names)
  for _, name in ipairs(names) do
    local device = hs.audiodevice.findOutputByName(name)
    if device then
      return device
    end
  end
end

local function contains(names, value)
  for _, name in ipairs(names) do
    if name == value then
      return true
    end
  end

  return false
end

local function showAlert(message)
  hs.alert.closeAll()
  hs.alert.show(message)
end

-- Swap between ranked primary outputs and secondary/headphone outputs.
local function toggleOutput()
  local currentDevice = hs.audiodevice.defaultOutputDevice()
  local currentDeviceName = currentDevice and currentDevice:name()
  local candidates = contains(primaryOutputs, currentDeviceName) and secondaryOutputs or primaryOutputs
  local nextDevice = findFirstAvailable(candidates)

  if not nextDevice then
    showAlert("No alternate audio output")
    return
  end

  if not nextDevice:setDefaultOutputDevice() then
    showAlert("Audio output switch failed")
    return
  end

  showAlert(nextDevice:name() or "Audio output changed")
end

hyper:bind({}, "s", nil, toggleOutput)
