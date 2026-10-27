local hyper = { "cmd", "ctrl", "alt" }
local hyperShift = { "cmd", "ctrl", "alt", "shift" }

local hyperBindings = {
  -- Top Row: IM + Spotify
  { hyper,      "t", "Twitch" },
  { hyper,      "y", "YouTube" },
  { hyper,      "u", "Slack" },
  { hyperShift, "u", "WhatsApp" },
  { hyper,      "i", "Messages" },
  { hyperShift, "i", "Discord" },
  { hyper,      "o", "Messenger" },
  { hyperShift, "o", "OBS" },
  { hyper,      "p", "Spotify" },


  -- Middle Row: Main Apps
  { hyper,      "d", "DevDocs" },
  { hyperShift, "d", "BoltAI" },
  { hyper,      "g", "Google Meet" },
  { hyperShift, "g", "zoom.us" },
  { hyper,      "h", "com.culturedcode.ThingsMac" },
  { hyperShift, "h", "Linear" },
  { hyper,      "j", "Google Chrome" },
  { hyperShift, "j", "Firefox Developer Edition" },
  { hyper,      "k", "Visual Studio Code" },
  { hyper,      "l", "Ghostty" },
  { hyper,      ";", "Figma" },

  -- Bottom Row: Email, Calendar and ToDos
  { hyper,      "b", "ChatGPT" },
  { hyper,      "n", "Obsidian" },
  { hyperShift, "n", "Notion" },
  { hyper,      "m", "Gmail" },
  { hyper,      ",", "Calendar" },
  { hyper,      ".", "Finder" },
}

for _, binding in ipairs(hyperBindings) do
  local app = binding[3]
  hs.hotkey.bind(binding[1], binding[2], nil, function()
    if not hs.application.launchOrFocus(app) then
      hs.application.launchOrFocusByBundleID(app)
    end
  end)
end
