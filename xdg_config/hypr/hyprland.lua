-- Generated from Home Manager NixOS modules.
-- See https://wiki.hypr.land/Configuring/Start/
if package.searchpath("hyprgrass", package.path) then
  require("hyprgrass")
end

-- ============== ENVIRONMENT VARIABLES ==============
-- (from env.nix — set these via hl.env or your session manager)
hl.env("QT_QPA_PLATFORM", "wayland")
hl.env("QT_QPA_PLATFORMTHEME", "qt6ct")
hl.env("QT_WAYLAND_DISABLE_WINDOWDECORATION", "1")
hl.env("QT_AUTO_SCREEN_SCALE_FACTOR", "1")
hl.env("QT_SCALE_FACTOR_ROUNDING_POLICY", "RoundPreferFloor")
hl.env("GDK_BACKEND", "wayland")
hl.env("GDK_SCALE", "2")
hl.env("GTK_USE_PORTAL", "1")
hl.env("SDL_VIDEODRIVER", "wayland")
hl.env("SDL_TOUCH_MOUSEID_HANDLING", "1")
hl.env("_JAVA_AWT_WM_NONREPARENTING", "1")
hl.env("CLUTTER_BACKEND", "wayland")
hl.env("MOZ_ENABLE_WAYLAND", "1")
hl.env("MOZ_ACCELERATED", "1")
hl.env("MOZ_WEBRENDER", "1")
hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_TYPE", "wayland")
hl.env("XDG_SESSION_DESKTOP", "Hyprland")
hl.env("TZDATA", "/etc/zoneinfo")

-- TERM is set by your terminal emulator; set manually here if needed:
-- hl.env("TERM", "kitty")

-- ============== AUTOSTART ==============
hl.on("hyprland.start", function()
  local function restart(cmd)
    local bin = cmd:match("^(%S+)")
    hl.dispatch(hl.dsp.exec_cmd("sh -c 'pgrep -x " .. bin .. " && pkill -x " .. bin .. "; " .. cmd .. "'"))
  end

  hl.dispatch(hl.dsp.exec_cmd("systemctl --user import-environment && systemctl --user start hyprland-session.target"))
  restart("noctalia-shell")
  restart("solaar --window=hide")
  hl.dispatch(hl.dsp.exec_cmd("wl-paste --watch cliphist store"))
end)

-- ============== MONITOR ==============
-- (from monitors.nix)
hl.monitor({
  output   = "eDP-1",
  mode     = "preferred",
  position = "auto",
  scale    = 1.5,
})

-- On startup: switch to clamshell profile if lid is already closed
hl.on("hyprland.start", function()
  hl.dispatch(hl.dsp.exec_cmd(
    "grep closed /proc/acpi/button/lid/LID0/state && shikanectl switch clamshell"
  ))
end)

-- Workspace-to-monitor pinning (from monitors.nix)
hl.workspace_rule({ workspace = "7", monitor = "eDP-1" })
hl.workspace_rule({ workspace = "8", monitor = "eDP-1" })
hl.workspace_rule({ workspace = "9", monitor = "eDP-1" })
hl.workspace_rule({ workspace = "10", monitor = "eDP-1", default = true })

-- ============== GENERAL ==============
hl.config({
  general = {
    allow_tearing = true,
    border_size   = 2,
    col           = {
      active_border   = "rgba(ffe3aaff)",
      inactive_border = "rgba(6d6483ff)",
    },
    gaps_in       = 4,
    -- CSS-style string not accepted; use a table or single integer instead
    gaps_out      = { top = 8, right = 8, bottom = 8, left = 8 },
    layout        = "dwindle",
  }
})

-- ============== INPUT ==============
hl.config({
  input = {
    kb_layout      = "us",
    follow_mouse   = 1,
    natural_scroll = true,
    sensitivity    = 0,

    touchpad       = {
      natural_scroll = true,
      scroll_factor  = 0.5,
    },

    touchdevice    = {
      enabled = true,
      output  = "eDP-1",
    },
  }
})

-- ============== DECORATION ==============
hl.config({
  decoration = {
    blur     = { enabled = true },
    rounding = 8,
    shadow   = { enabled = false },
  }
})

-- ============== ANIMATIONS ==============
hl.config({
  animations = { enabled = true }
})

hl.animation({ leaf = "windows", enabled = true, speed = 6, bezier = "default", style = "popin 80%" })
hl.animation({ leaf = "border", enabled = true, speed = 6, bezier = "default" })
hl.animation({ leaf = "fade", enabled = true, speed = 6, bezier = "default" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 8, bezier = "default", style = "slidevert" })

-- ============== SCROLLING LAYOUT ==============
hl.config({
  scrolling = { fullscreen_on_one_column = false }
})

-- ============== XWAYLAND ==============
hl.config({
  xwayland = { force_zero_scaling = true }
})

-- ============== PLUGINS ===============
local hyprgrass = os.getenv("HYPRGRASS_PLUGIN")
if hyprgrass then
  hl.plugin(hyprgrass)
  hl.plugin_config("hyprgrass", {
    sensitivity = 4.0,
    workspace_swipe_edge = ""
  })

  hl.plugin.hyprgrass.gesture {
    gesture = { kind = "swipe", fingers = 3, direction = "vertical" },
    action = "workspace",
  }
end

-- ============== GESTURES (trackpad) ==============
-- 3-finger vertical swipe → switch workspace
hl.gesture({ fingers = 3, direction = "vertical", action = "workspace" })
-- 3-finger horizontal swipes → scroll layout columns (scrolling layout only)
-- (hl.gesture has no "dispatcher" action; use a Lua function instead)
hl.gesture({
  fingers = 3,
  direction = "left",
  action = function()
    if currentLayout == "scrolling" then
      hl.dispatch(hl.dsp.layout("move +col"))
    end
  end
})
hl.gesture({
  fingers = 3,
  direction = "right",
  action = function()
    if currentLayout == "scrolling" then
      hl.dispatch(hl.dsp.layout("move -col"))
    end
  end
})

-- ============== KEYBINDS ==============
local mainMod          = "SUPER"
local qs               = "noctalia-shell ipc call"

-- Layout state
local BORDER_DWINDLE   = "rgba(ffe3aaff)"
local BORDER_SCROLLING = "rgba(aaffb2ff)"
local currentLayout    = "dwindle"

local function setLayout(name)
  currentLayout = name
  hl.config({
    general = {
      layout = name,
      col = {
        active_border   = name == "scrolling" and BORDER_SCROLLING or BORDER_DWINDLE,
        inactive_border = "rgba(6d6483ff)",
      },
    }
  })
end

-- Applications
hl.bind(mainMod .. " + T", hl.dsp.exec_cmd("kitty"))
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd("dolphin " .. (os.getenv("HOME") or "~")))
hl.bind(mainMod .. " + B",
  hl.dsp.exec_cmd("flatpak run com.brave.Browser --password-store=detect --disable-features=WaylandWpColorManagerV1"))
hl.bind(mainMod .. " + M", hl.dsp.exec_cmd("thunderbird"))
hl.bind(mainMod .. " + D", hl.dsp.exec_cmd(qs .. " launcher toggle"))
hl.bind(mainMod .. " + SHIFT + V", hl.dsp.exec_cmd(qs .. " plugin:clipper openPanel"))

-- Close
hl.bind(mainMod .. " + Q", hl.dsp.window.close())

-- Screenshots
hl.bind(mainMod .. " + CTRL + 3", hl.dsp.exec_cmd("grim"))
hl.bind(mainMod .. " + CTRL + 4", hl.dsp.exec_cmd("grim -g \"$(slurp)\""))

-- Session menu
hl.bind("CTRL + ALT + DELETE", hl.dsp.exec_cmd(qs .. " sessionMenu toggle"))

-- Focus movement (arrow keys + hjkl)
hl.bind(mainMod .. " + left", hl.dsp.focus({ direction = "l" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "r" }))
hl.bind(mainMod .. " + up", hl.dsp.focus({ direction = "u" }))
hl.bind(mainMod .. " + down", hl.dsp.focus({ direction = "d" }))
hl.bind(mainMod .. " + H", hl.dsp.focus({ direction = "l" }))
hl.bind(mainMod .. " + L", hl.dsp.focus({ direction = "r" }))
hl.bind(mainMod .. " + K", hl.dsp.focus({ direction = "u" }))
hl.bind(mainMod .. " + J", hl.dsp.focus({ direction = "d" }))

-- Layout toggle (dwindle ↔ scrolling)
hl.bind(mainMod .. " + SHIFT + L", function()
  setLayout(currentLayout == "dwindle" and "scrolling" or "dwindle")
end)

-- Layout controls (scrolling layout only)
-- Tap: colresize 1.0; Hold: fullscreen (fullscreen works in both layouts)
local fHoldFired = false
local fHoldTimer = nil
hl.bind(mainMod .. " + F", function()
  fHoldFired = false
  fHoldTimer = hl.timer(function()
    fHoldFired = true
    hl.dispatch(hl.dsp.window.fullscreen({ mode = "fullscreen" }))
  end, { timeout = 400, type = "oneshot" })
end)
hl.bind(mainMod .. " + F", function()
  if fHoldTimer then
    fHoldTimer:set_enabled(false)
    fHoldTimer = nil
  end
  if not fHoldFired and currentLayout == "scrolling" then
    hl.dispatch(hl.dsp.layout("colresize 1.0"))
  end
end, { release = true })

hl.bind(mainMod .. " + R", function()
  if currentLayout == "scrolling" then
    hl.dispatch(hl.dsp.layout("colresize +conf"))
  end
end)
hl.bind(mainMod .. " + SHIFT + R", function()
  if currentLayout == "scrolling" then
    hl.dispatch(hl.dsp.layout("colresize -conf"))
  end
end)
hl.bind(mainMod .. " + bracketleft", function()
  if currentLayout == "scrolling" then
    hl.dispatch(hl.dsp.layout("swapcol l"))
  end
end)
hl.bind(mainMod .. " + bracketright", function()
  if currentLayout == "scrolling" then
    hl.dispatch(hl.dsp.layout("swapcol r"))
  end
end)
hl.bind(mainMod .. " + backslash", function()
  if currentLayout == "scrolling" then
    hl.dispatch(hl.dsp.layout("promote"))
  end
end)

-- Move current workspace to a monitor in a direction
-- (hl.dsp.workspace.move_to_monitor does not exist; use exec_raw)
hl.bind(mainMod .. " + SHIFT + up", hl.dsp.workspace.move({ monitor = "u" }))
hl.bind(mainMod .. " + SHIFT + down", hl.dsp.workspace.move({ monitor = "d" }))
hl.bind(mainMod .. " + SHIFT + left", hl.dsp.workspace.move({ monitor = "l" }))
hl.bind(mainMod .. " + SHIFT + right", hl.dsp.workspace.move({ monitor = "r" }))
hl.bind(mainMod .. " + SHIFT + K", hl.dsp.workspace.move({ monitor = "u" }))
hl.bind(mainMod .. " + SHIFT + J", hl.dsp.workspace.move({ monitor = "d" }))
hl.bind(mainMod .. " + SHIFT + H", hl.dsp.workspace.move({ monitor = "l" }))
-- Note: SHIFT + L is used for layout toggle

-- Special workspace (scratchpad)
hl.bind(mainMod .. " + SHIFT + minus", hl.dsp.window.move({ workspace = "special" }))
hl.bind(mainMod .. " + SHIFT + BackSpace", hl.dsp.window.move({ workspace = "special" }))
hl.bind(mainMod .. " + SHIFT + P", hl.dsp.workspace.toggle_special())

-- Mirror eDP-1 to first connected DP-x output
hl.bind(mainMod .. " + SHIFT + M", hl.dsp.exec_cmd([[
  DP_OUT=$(hyprctl monitors -j | jq -r '.[] | select(.name | test("^DP-")) | .name' | head -n1)
  [ -n "$DP_OUT" ] && wl-present mirror eDP-1 --fullscreen-output "$DP_OUT" --fullscreen
]]))

-- Float / center focused window
hl.bind(mainMod .. " + SHIFT + Return", function()
  hl.dispatch(hl.dsp.window.move({ workspace = "e+0" }))
  hl.dispatch(hl.dsp.window.float({ action = "toggle" }))
  hl.dispatch(hl.dsp.window.center())
end)

hl.bind(mainMod .. " + SHIFT + Space", hl.dsp.window.pseudo())

-- Workspace switching and window-to-workspace (keys 1-9, 0→10)
for i = 1, 9 do
  hl.bind(mainMod .. " + " .. i, hl.dsp.focus({ workspace = i }))
  hl.bind(mainMod .. " + SHIFT + " .. i, hl.dsp.window.move({ workspace = i }))
end
hl.bind(mainMod .. " + 0", hl.dsp.focus({ workspace = 10 }))
hl.bind(mainMod .. " + SHIFT + 0", hl.dsp.window.move({ workspace = 10 }))

-- Media keys
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("pactl set-sink-volume 0 +5%"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("pactl set-sink-volume 0 -5%"), { locked = true, repeating = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("pactl set-sink-mute 0 toggle"), { locked = true })
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("pactl set-source-mute alsa_input.pci-0000_00_1b.0.analog-stereo toggle"),
  { locked = true })
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl -q s +10%"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -q s 10%-"), { locked = true, repeating = true })

-- Lid switch (locked = fires even on lock screen)
hl.bind("switch:off:Lid Switch", hl.dsp.exec_cmd("shikanectl reload"), { locked = true })
hl.bind("switch:on:Lid Switch", hl.dsp.exec_cmd("shikanectl switch clamshell"), { locked = true })

-- Mouse window move / resize
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- ============== WINDOW RULES ==============
-- (from windowrules.nix)
local function floatRule(match)
  hl.window_rule({ match = match, float = true })
end

floatRule({ class = "^(org.kde..*)" })
floatRule({ class = "^(org.gnome..*)" })
floatRule({ class = "^(org.remmina..*)" })
floatRule({ class = "kdesystemsettings" })
floatRule({ class = "^(org.freedesktop.impl.portal.desktop..*)" })
floatRule({ class = "^(xdg-desktop-portal..*)" })
floatRule({ class = "mpv" })
floatRule({ class = "pavucontrol" })
floatRule({ class = "virt-manager" })
floatRule({ class = "nm-connection-editor" })
hl.window_rule({ match = { class = "kicad", title = "^(.*KiCad.*)$" }, float = true })
floatRule({ class = "nwg-look" })
floatRule({ class = "hyprland-share-picker" })
floatRule({ class = "org.gnome.NetworkDisplays" })
hl.window_rule({ match = { class = "naps2", title = "^(?!NAPS2 -)(.*)$" }, float = true })
floatRule({ class = "^(org.fcitx..*)" })

hl.window_rule({ match = { class = "org.mozilla.Thunderbird", initial_title = "^$" }, float = true })
hl.window_rule({ match = { class = "org.mozilla.Thunderbird", initial_title = "^Write.*$" }, float = true })
floatRule({ initial_title = "MainPicker" })

-- Popup size constraints
hl.window_rule({ match = { class = "org.kde.dolphin" }, size = "780 520" })
hl.window_rule({ match = { class = "^(xdg-desktop-portal-.*)" }, size = "780 520" })

-- Layer rules
hl.layer_rule({ match = { namespace = "wvkbd" }, above_lock = 2 })
