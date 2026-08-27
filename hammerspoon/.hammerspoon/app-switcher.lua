local hyper = spoon.Hyper

local hyperBindings = {
  -- Top Row: IM + Spotify
  { {}, "t", "Twitch" },
  { { "shift" }, "t", "Twitch - Dashboard" },
  { {}, "y", "YouTube" },
  { {}, "u", "Slack" },
  { { "shift" }, "u", "Facebook" },
  { {}, "i", "Messages" },
  { { "shift" }, "i", "Discord" },
  { {}, "o", "WhatsApp" },
  { { "shift" }, "o", "OBS" },
  { {}, "p", "Spotify" },


  -- Middle Row: Main Apps
  { {}, "d", "DevDocs" },
  { { "shift" }, "d", "BoltAI" },
  { {}, "g", "Google Meet" },
  { { "shift" }, "g", "zoom.us" },
  { {}, "h", "com.culturedcode.ThingsMac" },
  { { "shift" }, "h", "Linear" },
  { {}, "j", "Google Chrome" },
  { { "shift" }, "j", "Firefox Developer Edition" },
  { {}, "k", "Visual Studio Code" },
  { {}, "l", "Ghostty" },
  { {}, ";", "Figma" },

  -- Bottom Row: Email, Calendar and ToDos
  { {}, "b", "Claude" },
  { {}, "n", "Obsidian" },
  { { "shift" }, "n", "Notion" },
  { {}, "m", "Mimestream" },
  { {}, ",", "Calendar" },
  { {}, ".", "Finder" },
}

for _, binding in ipairs(hyperBindings) do
  local app = binding[3]
  hyper:bind(binding[1], binding[2], nil, function()
    if not hs.application.launchOrFocus(app) then
      hs.application.launchOrFocusByBundleID(app)
    end
  end)
end
