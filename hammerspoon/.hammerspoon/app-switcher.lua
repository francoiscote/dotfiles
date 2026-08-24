local hyper = { "cmd", "alt", "ctrl" }
local hyperShift = { "cmd", "alt", "ctrl", "shift" }

local log = hs.logger.new('WM', 'debug')

local charToApps = {
  -- Top Row: IM + Spotify
  { {},          't', 'Twitch' },
  { { 'shift' }, 't', 'Twitch - Dashboard', },
  { {},          'y', 'YouTube' },
  { {},          'u', 'Slack' },
  { { 'shift' }, 'u', 'Facebook', },
  { {},          'i', 'Messages' },
  { { 'shift' }, 'i', 'Discord', },
  { {},          'o', 'WhatsApp' },
  { { 'shift' }, 'o', 'OBS', },
  { {},          'p', 'Spotify' },


  -- Middle Row: Main Apps
  { {},          'd', 'DevDocs' },
  { { 'shift' }, 'd', 'BoltAI', },
  { {},          'g', 'Google Meet' },
  { { 'shift' }, 'g', 'zoom.us', },
  { {},          'h', 'com.culturedcode.ThingsMac' },
  { { 'shift' }, 'h', 'Linear', },
  { {},          'l', 'Ghostty' },
  { {},          ';', 'Figma' },

  -- Bottom Row: Email, Calendar and ToDos
  { {},          'b', 'Claude' },
  { {},          'n', 'Obsidian' },
  { { 'shift' }, 'n', 'Notion', },
  { {},          'm', 'Mimestream' },
  { {},          ',', 'Calendar' },
  { {},          '.', 'Finder' },
}

hs.fnutils.each(charToApps, function(entry)
  log.d("entry", entry[2])
  Hyper:bind(entry[1], entry[2], function()
    if not hs.application.launchOrFocus(entry[3]) then
      hs.application.launchOrFocusByBundleID(entry[3])
    end
  end)
end)

-- App groups
-- from evantravers: https://github.com/evantravers/dotfiles/blob/master/users/evantravers/.config/hammerspoon/init.lua
-------------------------------------------------------------------------------
local chooseFromGroup = function(choice)
  local name = hs.application.nameForBundleID(choice.bundleID)

  hs.notify.new(nil)
      :title("Switching ✦-" .. choice.key .. " to " .. name)
      :contentImage(hs.image.imageFromAppBundle(choice.bundleID))
      :send()

  hs.settings.set("hyperGroup." .. choice.key, choice.bundleID)
  hs.application.launchOrFocusByBundleID(choice.bundleID)
end

local hyperGroup = function(key, group)
  Hyper:bind({}, key, nil, function()
    hs.application.launchOrFocusByBundleID(hs.settings.get("hyperGroup." .. key))
  end)
  Hyper:bind({ 'option' }, key, nil, function()
    print("Setting options…")
    local choices = {}
    hs.fnutils.each(group, function(bundleID)
      table.insert(choices, {
        text = hs.application.nameForBundleID(bundleID),
        image = hs.image.imageFromAppBundle(bundleID),
        bundleID = bundleID,
        key = key
      })
    end)

    if #choices == 1 then
      chooseFromGroup(choices[1])
    else
      hs.chooser.new(chooseFromGroup)
          :placeholderText("Choose an application for hyper+" .. key .. ":")
          :choices(choices)
          :show()
    end
  end)
end

hyperGroup('j', {
  'com.google.Chrome',
  'com.apple.Safari',
  'org.mozilla.firefox',
})

hyperGroup('k', {
  'com.microsoft.VSCode',
  'dev.zed.Zed',
})
