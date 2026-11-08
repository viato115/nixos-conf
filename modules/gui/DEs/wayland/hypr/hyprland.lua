-- Shared Hyprland configuration. Home Manager adds each host's monitor rules.
hl.config({
  input = {
    kb_layout = "de",
    follow_mouse = 2,
    -- The final sensitivity assignment in the old configuration was 0.
    sensitivity = 0,
    accel_profile = "flat",
    numlock_by_default = true,
    touchpad = {
      natural_scroll = false,
      disable_while_typing = true,
      scroll_factor = 0.5,
      ["tap-to-click"] = true,
      clickfinger_behavior = true,
    },
  },

  general = {
    gaps_in = 5,
    gaps_out = 13,
    border_size = 0,
    col = {
      active_border = {
        colors = { "rgb(44475a)", "rgb(bd93f9)" },
        angle = 90,
      },
      inactive_border = "rgba(44475aaa)",
    },
    layout = "master",
  },

  decoration = {
    rounding = 6,
    active_opacity = 1.0,
    inactive_opacity = 1.0,
    shadow = {
      enabled = true,
      color = "rgba(0a0e14aa)",
      render_power = 3,
      range = 18,
    },
    blur = {
      enabled = true,
      size = 8,
      passes = 2,
      new_optimizations = true,
    },
  },

  animations = { enabled = true },
  dwindle = { preserve_split = true },
  master = {
    allow_small_split = false,
    new_status = "slave",
    new_on_top = false,
    new_on_active = "none",
    orientation = "left",
    smart_resizing = true,
    drop_at_cursor = true,
  },
  gestures = {
    workspace_swipe_create_new = false,
    workspace_swipe_forever = false,
  },
  misc = {
    animate_manual_resizes = true,
    enable_swallow = true,
    swallow_regex = "^(foot)$",
  },
  cursor = {
    inactive_timeout = 5,
    hide_on_touch = true,
    enable_hyprcursor = true,
  },
})

hl.curve("pace", { type = "bezier", points = { { 0.46, 1 }, { 0.29, 0.99 } } })
hl.curve("overshot", { type = "bezier", points = { { 0.13, 0.99 }, { 0.29, 1.1 } } })
hl.curve("md3_decel", { type = "bezier", points = { { 0.05, 0.7 }, { 0.1, 1 } } })

hl.animation({ leaf = "windowsIn", enabled = true, speed = 6, bezier = "md3_decel", style = "slide" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 6, bezier = "md3_decel", style = "slide" })
hl.animation({ leaf = "windowsMove", enabled = true, speed = 6, bezier = "md3_decel", style = "slide" })
hl.animation({ leaf = "fade", enabled = true, speed = 10, bezier = "md3_decel" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 7, bezier = "md3_decel", style = "slide" })
hl.animation({ leaf = "specialWorkspace", enabled = true, speed = 8, bezier = "md3_decel", style = "slide" })
hl.animation({ leaf = "border", enabled = false })

-- Home Manager starts Dunst and hyprpaper and imports the session environment.
hl.on("hyprland.start", function()
  hl.exec_cmd("waybar")
  hl.exec_cmd("foot --server")
end)

local mainMod = "SUPER"

-- Keep the Waybar press/release bindings and the separate Super+B toggle.
hl.bind(mainMod .. " + SUPER_L", hl.dsp.exec_cmd("pkill -SIGUSR1 waybar"), { ignore_mods = true, transparent = true })
hl.bind(mainMod .. " + SUPER_L", hl.dsp.exec_cmd("pkill -SIGUSR1 waybar"), { ignore_mods = true, release = true, transparent = true })
hl.bind(mainMod .. " + B", hl.dsp.exec_cmd("pkill -SIGUSR1 waybar"))

hl.bind(mainMod .. " + T", hl.dsp.exec_cmd("alacritty"))
hl.bind(mainMod .. " + Return", hl.dsp.exec_cmd("footclient"))
hl.bind(mainMod .. " + SHIFT + Return", hl.dsp.exec_cmd("kitty"))
hl.bind(mainMod .. " + C", hl.dsp.window.close())
hl.bind(mainMod .. " + D", hl.dsp.exec_cmd("rofi -show drun"))
hl.bind(mainMod .. " + A", hl.dsp.exec_cmd("rofi -show favorites"))
hl.bind(mainMod .. " + SHIFT + E", hl.dsp.exec_cmd("rofi -show filebrowser"))
hl.bind(mainMod .. " + W", hl.dsp.exec_cmd("firefox-beta"))
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd("dolphin"))
hl.bind(mainMod .. " + SHIFT + SPACE", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + R", hl.dsp.exec_cmd("/usr/local/bin/iio-hyprland"))
hl.bind(mainMod .. " + SHIFT + R", hl.dsp.exec_cmd("pkill iio-hyprland"))
hl.bind(mainMod .. " + P", hl.dsp.window.pseudo())
hl.bind(mainMod .. " + J", hl.dsp.layout("togglesplit"))
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen())
hl.bind(mainMod .. " + SHIFT + O", hl.dsp.exec_cmd("~/scripts/screenshot.sh"))

-- Preserve the existing focus directions, including Super+Shift+K/J.
hl.bind(mainMod .. " + SHIFT + h", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + SHIFT + l", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + SHIFT + k", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + SHIFT + j", hl.dsp.focus({ direction = "down" }))

for workspace = 1, 10 do
  local key = workspace % 10
  hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = workspace }))
  hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = workspace }))
end

hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

for key, direction in pairs({ left = "left", right = "right", up = "up", down = "down" }) do
  hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ direction = direction }))
  hl.bind(mainMod .. " + CTRL + SHIFT + " .. key, hl.dsp.window.move({ monitor = direction:sub(1, 1) }))
end

-- odiaeresis is the XKB keysym for the German O-umlaut key.
hl.bind(mainMod .. " + odiaeresis", hl.dsp.focus({ workspace = "special" }))
hl.bind(mainMod .. " + SHIFT + odiaeresis", hl.dsp.window.move({ workspace = "special" }))
hl.bind(mainMod .. " + ALT + H", hl.dsp.workspace.toggle_special("eDP-1"))

hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl set +5%"))
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl set 5%-"))
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 6%+"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 6%-"), { locked = true, repeating = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), { locked = true })
