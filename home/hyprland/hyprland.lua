local function run(cmd)
    local f = io.popen(cmd)
    if not f then return nil end
    local out = f:read("*a")
    f:close()
    return out
end

local monitors_json = run("hyprctl -j monitors")

-- Use whatever JSON library Hyprland exposes.
-- If none is available:
local json = require("json")

local monitors = json.decode(monitors_json)

local names = {}
for _, mon in ipairs(monitors) do
    table.insert(names, mon.name)
end

table.sort(names)

local monitor_set = table.concat(names, " ")

print("MONITORS=" .. monitor_set)

if monitor_set == "DP-2 HDMI-A-1" then
    print("mainix detected")

    hl.monitor("DP-2,2560x1440@144,0x0,1")
    hl.monitor("HDMI-A-1,1920x1080@60,2560x180,1")

    for i = 1, 7 do
        hl.workspace(i, { monitor = "DP-2" })
        hl.dispatch("moveworkspacetomonitor", tostring(i) .. " DP-2")
    end

    for i = 8, 10 do
        hl.workspace(i, { monitor = "HDMI-A-1" })
        hl.dispatch("moveworkspacetomonitor", tostring(i) .. " HDMI-A-1")
    end

    hl.keyword("input:sensitivity", "-1.0")
else
    hl.monitor(",preferred,auto,1")
end

-- Execute apps at startup
hl.exec("hyprpanel & hyprpaper")

-- Source additional config if needed
hl.exec("source ~/.secret/hypr.conf")

-- Input
hl.input({
    kb_layout = { "us", "ru" },
    kb_variant = "",
    kb_model = "",
    kb_options = "grp:win_space_toggle",
    follow_mouse = true,
    touchpad = { natural_scroll = false }
})

-- General settings
hl.general({
    gaps_in = 5,
    gaps_out = 20,
    border_size = 2,
    col = {
        active_border = { "#33ccffee", "#00ff99ee", "45deg" },
        inactive_border = "#595959aa"
    },
    resize_on_border = true,
    layout = "dwindle"
})

-- Cursor
hl.cursor({
    inactive_timeout = 5,
    no_hardware_cursors = true
})

-- Decoration
hl.decoration({
    rounding = 0,
    shadow = {
        enabled = true,
        range = 4,
        render_power = 3,
        color = "#1a1a1aee"
    }
})

-- Animations
hl.animations({
    enabled = true,
    bezier = { "myBezier", 0.05, 0.9, 0.1, 1.05 },
    animation = {
        { type = "windows",   time1 = 1, time2 = 7, curve = "myBezier" },
        { type = "windowsOut", time1 = 1, time2 = 7, curve = "default", effect = "popin 80%" },
        { type = "border",    time1 = 1, time2 = 10, curve = "default" },
        { type = "borderangle", time1 = 1, time2 = 8, curve = "default" },
        { type = "fade",      time1 = 1, time2 = 7, curve = "default" },
        { type = "workspaces", time1 = 1, time2 = 6, curve = "default" }
    }
})

-- Layouts
hl.dwindle({ pseudotile = true, preserve_split = true })
hl.master({ new_status = "master" })

-- Device
hl.device({
    name = "epic-mouse-v1",
    sensitivity = -0.5
})

-- Window rules
hl.windowrule({
    name = "red-border-for-fullscreen",
    match = { fullscreen = true },
    border_color = { "#FF0000", "#880808" }
})

-- Keybinds
local mainMod = "SUPER"

-- Simple bind helper
local function bind(mod, key, action, target)
    hl.bind(mod .. " + " .. key, function()
        hl.dispatch(action, target)
    end)
end

-- Example binds
bind(mainMod, "T", "exec", "alacritty")
bind("ALT", "F4", "killactive")
bind(mainMod .. " + ALT", "Escape", "exit")
bind(mainMod, "V", "togglefloating")
bind(mainMod, "P", "pseudo")
bind(mainMod, "backslash", "togglesplit")
bind(mainMod, "P", "exec", "hyprpicker --autocopy")
bind(mainMod .. " + SHIFT", "P", "pin", "active")
bind(mainMod, "C", "centerwindow")

-- Workspaces (1–10)
for i = 1, 10 do
    bind(mainMod, tostring(i % 10), "workspace", i)
    bind(mainMod .. " + SHIFT", tostring(i % 10), "movetoworkspace", i)
end

-- Mouse binds
hl.bind(mainMod .. " + mouse:272", function() hl.movewindow() end)
hl.bind(mainMod .. " + mouse:273", function() hl.resizewindow() end)

-- Volume keys
hl.bind("XF86AudioRaiseVolume", function()
    hl.exec("wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%+")
end)

hl.bind("XF86AudioLowerVolume", function()
    hl.exec("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-")
end)

hl.bind("XF86AudioMute", function()
    hl.exec("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle")
end)
