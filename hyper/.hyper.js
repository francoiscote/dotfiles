// Future versions of Hyper may add additional config options,
// which will not automatically be merged into this file.
// See https://hyper.is#cfg for all currently supported options.

module.exports = {
  config: {
    // Choose either "stable" for receiving highly polished,
    // or "canary" for less polished but more frequent updates
    updateChannel: "stable",

    // default font size in pixels for all tabs
    fontSize: 13,

    // font family with optional fallbacks
    fontFamily:
      '"Operator Mono SSm Lig"',

    fontWeight: "500",
    fontWeightBold: "500",

    // `BEAM` for |, `UNDERLINE` for _, `BLOCK` for █
    cursorShape: "UNDERLINE",

    // set to true for blinking cursor
    cursorBlink: true,

    // set to `true` (without backticks) if you're using a Linux setup that doesn't show native menus
    // default: `false` on Linux, `true` on Windows (ignored on macOS)
    showHamburgerMenu: "true",

    // set to `false` if you want to hide the minimize, maximize and close buttons
    // additionally, set to `'left'` if you want them on the left, like in Ubuntu
    // default: `true` on windows and Linux (ignored on macOS)
    showWindowControls: "",

    // custom padding (css format, i.e.: `top right bottom left`)
    padding: "12px 14px",

    // the full list. if you're going to provide the full color palette,
    // including the 6 x 6 color cubes and the grayscale map, just provide
    // an array here instead of a color map object
    colors: {
      black: "#4a4543",
      red: "#db90a7",
      green: "#87b6b6",
      yellow: "#ffb4b8",
      blue: "#32abde",
      magenta: "#be88d9",
      cyan: "#958ac5",
      white: "#f1ecee",
      lightBlack: "#e7cecd",
      lightRed: "#eeaabe",
      lightGreen: "#98c4ba",
      lightYellow: "#e7d59a",
      lightBlue: "#82b3e2",
      lightMagenta: "#ce9ae8",
      lightCyan: "#b4addf",
      lightWhite: "#FFFFFF"
    },

    // color of the text
    foregroundColor: "#c29ba3",

    // terminal background color
    backgroundColor: "#f1ecee",

    // border color (window, tabs)
    borderColor: "#c29ba3",

    // terminal cursor background color and opacity (hex, rgb, hsl, hsv, hwb or cmyk)
    cursorColor: "#c29ba3",

    // custom css to embed in the main window
    css: "",

    // the shell to run when spawning a new session (i.e. /usr/local/bin/fish)
    // if left empty, your system's login shell will be used by default
    //
    // Windows
    // - Make sure to use a full path if the binary name doesn't work
    // - Remove `--login` in shellArgs
    //
    // Bash on Windows
    // - Example: `C:\\Windows\\System32\\bash.exe`
    //
    // Powershell on Windows
    // - Example: `C:\\WINDOWS\\System32\\WindowsPowerShell\\v1.0\\powershell.exe`
    shell: "",

    // for setting shell arguments (i.e. for using interactive shellArgs: ['-i'])
    // by default ['--login'] will be used
    shellArgs: ["--login"],

    // for environment variables
    env: {},

    // set to false for no bell
    bell: false,

    // if true, selected text will automatically be copied to the clipboard
    copyOnSelect: false,

    // if true, on right click selected text will be copied or pasted if no
    // selection is present (true by default on Windows)
    // quickEdit: true

    // URL to custom bell
    // bellSoundURL: 'http://example.com/bell.mp3',

    // for advanced config flags please refer to https://hyper.is/#cfg
    modifierKeys: {
      altIsMeta: true
    }

  },

  // a list of plugins to fetch and install from npm
  // format: [@org/]project[#version]
  // examples:
  //   `hyperpower`
  //   `@company/project`
  //   `project#1.0.1`
  plugins: ["hyperlinks"],

  hyperStatusLine: {
    footerTransparent: false,
  },

  // in development, you can create a directory under
  // `~/.hyper_plugins/local/` and include it here
  // to load it and avoid it being `npm install`ed
  localPlugins: [],

  keymaps: {
    // Example
    // 'window:devtools': 'cmd+alt+o',
  }
};
