-- TODO: Auto-updates

local application = require "mjolnir.application"
local hotkey = require "mjolnir.hotkey"
local window = require "mjolnir.window"
local fnutils = require "mjolnir.fnutils"
local alert = require "mjolnir.alert"
local notification = require "mjolnir._asm.ui.notification"
local grid = require "mjolnir.bg.grid"

-- Keyboard keys
hyper = {"cmd", "alt", "ctrl"}
hyperShift = {"cmd", "alt", "ctrl", "shift"}

-- Application titles
mail =      'Airmail Beta'
calendar =  'Sunrise'
browser =   'Google Chrome'
editor =    'Atom'
term =      'iTerm'
files =     'Finder'
im =        'Textual 5'
twitter =   'TweetDeck'
music =     'Spotify'
notes =     'Write'
todo =      'Wunderlist'

-- Grid Settings
grid.GRIDHEIGHT = 12;
grid.GRIDWIDTH = 12;


-- reload configs
hotkey.bind(hyper, "s", function()
  mjolnir.reload()
end)

-- open or focus applications
hotkey.bind(hyper, 'j', function() application.launchorfocus(browser) end)
hotkey.bind(hyper, 'k', function() application.launchorfocus(editor) end)
hotkey.bind(hyper, 'l', function() application.launchorfocus(mail) end)
hotkey.bind(hyper, 'h', function() application.launchorfocus(files) end)
hotkey.bind(hyper, 'i', function() application.launchorfocus(im) end)
hotkey.bind(hyper, 'o', function() application.launchorfocus(twitter) end)
hotkey.bind(hyper, 'p', function() application.launchorfocus(music) end)
hotkey.bind(hyper, 'n', function() application.launchorfocus(notes) end)
hotkey.bind(hyper, 'm', function() application.launchorfocus(todo) end)

-- Window Sizes
hotkey.bind(hyperShift, 'o', grid.maximize_window)

-- resize windows (centered)
hotkey.bind(hyperShift, 'H', grid.pushwindow_left)


hotkey.bind(hyperShift, 'J', function()
  grid.adjust_focused_window(function(c)
    c.x = c.x+1
    c.w = c.w-2
  end)
end)

hotkey.bind(hyperShift, 'K', function()
  grid.adjust_focused_window(function(c)
    c.x = math.max(c.y - 1, 0)
    c.w = c.w+2
    end)
    end)

hotkey.bind(hyperShift, 'L', grid.pushwindow_right)

-- resize windows
hotkey.bind(hyperShift, 'Y', grid.resizewindow_thinner)
hotkey.bind(hyperShift, 'U', grid.resizewindow_shorter)
hotkey.bind(hyperShift, 'I', grid.resizewindow_taller)
hotkey.bind(hyperShift, 'O', grid.resizewindow_wider)

-- Screen Move
hotkey.bind(hyperShift, 'space', grid.pushwindow_nextscreen)
