local hyper = {"cmd", "alt", "ctrl"}

-- Swap between a Main audio output and a series of ranked secondary outputs
-- Main Output: Vanatoo T0
-- Ranked Secondary Outputs:x
--   1) JDS Labs DAC
--   2) Yeti DAC
--   3) Elgato DAC
--   4) Laptop Speakers
-------------------------------------------------------------------------------
hs.hotkey.bind(hyper, "s", function()
  local currentDeviceName = hs.audiodevice.defaultOutputDevice():name()
  local nextDevice
  if string.find(currentDeviceName, 'Vanatoo T0') or string.find(currentDeviceName, 'USB audio CODEC') then
    nextDevice = hs.audiodevice.findOutputByName('EVO4')
    if (nextDevice == nil) then
      nextDevice = hs.audiodevice.findOutputByName('External Headphones')
    end
  else
    nextDevice = hs.audiodevice.findOutputByName('Vanatoo T0')
    if (nextDevice == nil) then
      nextDevice = hs.audiodevice.findOutputByName('USB audio CODEC')
    end
  end

  local didChange = nextDevice:setDefaultOutputDevice()
  -- Also set the default Effect device because of a bug where it would change to something random when using setDefaultOutputDevice()
  -- it can't keep the "Selected Sound Output Device" setting.
  nextDevice:setDefaultEffectDevice()

  if (didChange == true) then
    hs.alert.closeAll()
    hs.alert.show(nextDevice:name())
  end

  hyper.triggered = true
end)