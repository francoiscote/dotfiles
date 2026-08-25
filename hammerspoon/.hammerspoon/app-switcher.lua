local hyper = { "cmd", "alt", "ctrl" }
local hyperShift = { "cmd", "alt", "ctrl", "shift" }

local log = hs.logger.new('WM', 'debug')

local charToApps = {
  -- Top Row: IM + Spotify
  { Hyper,      't', 'Twitch' },
  { HyperShift, 't', 'Twitch - Dashboard', },
  { Hyper,      'y', 'YouTube' },
  { Hyper,      'u', 'Slack' },
  { HyperShift, 'u', 'Facebook', },
  { Hyper,      'i', 'Messages' },
  { HyperShift, 'i', 'Discord', },
  { Hyper,      'o', 'WhatsApp' },
  { HyperShift, 'o', 'OBS', },
  { Hyper,      'p', 'Spotify' },


  -- Middle Row: Main Apps
  { Hyper,      'd', 'DevDocs' },
  { HyperShift, 'd', 'BoltAI', },
  { Hyper,      'g', 'Google Meet' },
  { HyperShift, 'g', 'zoom.us', },
  { Hyper,      'h', 'com.culturedcode.ThingsMac' },
  { HyperShift, 'h', 'Linear' },
  { Hyper,      'j', 'Google Chrome' },
  { HyperShift, 'j', 'Firefox Developer Edition', },
  { Hyper,      'k', 'Visual Studio Code' },
  { Hyper,      'l', 'Ghostty' },
  { Hyper,      ';', 'Figma' },

  -- Bottom Row: Email, Calendar and ToDos
  { Hyper,      'b', 'Claude' },
  { Hyper,      'n', 'Obsidian' },
  { HyperShift, 'n', 'Notion', },
  { Hyper,      'm', 'Mimestream' },
  { Hyper,      ',', 'Calendar' },
  { Hyper,      '.', 'Finder' },
}

hs.fnutils.each(charToApps, function(entry)
  hs.hotkey.bind(entry[1], entry[2], nil, function()
    if not hs.application.launchOrFocus(entry[3]) then
      hs.application.launchOrFocusByBundleID(entry[3])
    end
  end)
end)
