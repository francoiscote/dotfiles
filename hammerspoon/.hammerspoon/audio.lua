-- Swap between a Speaker output and a series of ranked secondary outputs (headphones)
-- Main Output: Vanatoo T0 or Studio Display Speakers or Bluetooth connected Stereo system
-- Ranked Secondary Headphones: EVO4 or External Headphones or Macbook Pro Speakers
-------------------------------------------------------------------------------
Hyper:bind({}, 's', nil, function()
  local currentDeviceName = hs.audiodevice.defaultOutputDevice():name()
  local nextDevice
  if string.find(currentDeviceName, 'Vanatoo T0') or string.find(currentDeviceName, 'Studio Display Speakers') then
    nextDevice = hs.audiodevice.findOutputByName('François’s AirPods Pro')
    if (nextDevice == nil) then
      nextDevice = hs.audiodevice.findOutputByName('External Headphones')
    end
    if (nextDevice == nil) then
      nextDevice = hs.audiodevice.findOutputByName('MacBook Pro Speakers')
    end
  else
    nextDevice = hs.audiodevice.findOutputByName('Vanatoo T0')
    if (nextDevice == nil) then
      nextDevice = hs.audiodevice.findOutputByName('Studio Display Speakers')
    end
  end

  local didChange = false
  if (nextDevice ~= nil) then
    didChange = nextDevice:setDefaultOutputDevice()
    -- Also set the default Effect device because of a bug where it would change to something random when using setDefaultOutputDevice()
    -- it can't keep the "Selected Sound Output Device" setting.
    -- nextDevice:setDefaultEffectDevice()
    didChange = true;
  end

  if (didChange == true) then
    hs.alert.closeAll()
    hs.alert.show(nextDevice:name())
  end
end)
