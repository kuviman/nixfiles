-- local function run(cmd)
--     local f = io.popen(cmd)
--     if not f then return nil end
--     local out = f:read("*a")
--     f:close()
--     return out
-- end
--
-- local monitors_json = run("hyprctl -j monitors")
--
-- -- Use whatever JSON library Hyprland exposes.
-- -- If none is available:
-- local json = require("json")
--
-- local monitors = json.decode(monitors_json)
--
-- local names = {}
-- for _, mon in ipairs(monitors) do
--     table.insert(names, mon.name)
-- end
--
-- table.sort(names)
--
-- local monitor_set = table.concat(names, " ")
--
-- print("MONITORS=" .. monitor_set)
--
-- if monitor_set == "DP-2 HDMI-A-1" then
--     print("mainix detected")
--
--     hl.monitor("DP-2,2560x1440@144,0x0,1")
--     hl.monitor("HDMI-A-1,1920x1080@60,2560x180,1")
--
--     for i = 1, 7 do
--         hl.workspace(i, { monitor = "DP-2" })
--         hl.dispatch("moveworkspacetomonitor", tostring(i) .. " DP-2")
--     end
--
--     for i = 8, 10 do
--         hl.workspace(i, { monitor = "HDMI-A-1" })
--         hl.dispatch("moveworkspacetomonitor", tostring(i) .. " HDMI-A-1")
--     end
--
--     hl.keyword("input:sensitivity", "-1.0")
-- else
--     hl.monitor(",preferred,auto,1")
-- end

hl.monitor({
    output = "eDP-1",
    mode = "1920x1080@60",
    position = "0x0",
    scale = 1,
})

hl.on("hyprland.start", function()
    hl.exec_cmd("hyprpanel")
    hl.exec_cmd("hyprpaper")
end)

-- Source additional config if needed
-- hl.exec("source ~/.secret/hypr.conf")

hl.config({
    general = {
        gaps_in = 5,
        gaps_out = 20,
        border_size = 2,
        col = {
            active_border = {
                colors = {
                    "#33ccffee",
                    "#00ff99ee",
                },
                angle = 45,
            },
            inactive_border = "#595959aa"
        },
        resize_on_border = true,
        layout = "dwindle"
    },
    input = {
        kb_layout = "us,ru",
        kb_variant = "",
        kb_model = "",
        kb_options = "grp:win_space_toggle",
        follow_mouse = true,
        touchpad = { natural_scroll = false }
    },
    cursor = {
        inactive_timeout = 5,
        no_hardware_cursors = true
    },
    decoration = {
        rounding = 0,
        shadow = {
            enabled = true,
            range = 4,
            render_power = 3,
            color = "#1a1a1aee"
        }
    },
    dwindle = {
        preserve_split = true,
    },
    master = {
        new_status = "master",
    },
})

hl.curve("myBezier", { type = "bezier", points = { { 0.05, 0.9 }, { 0.1, 1.05 } } })
hl.animation({ leaf = "windows", enabled = true, speed = 2, bezier = "myBezier" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 2, bezier = "default", style = "popin 80%" })
hl.animation({ leaf = "border", enabled = true, speed = 2, bezier = "default" })
hl.animation({ leaf = "borderangle", enabled = true, speed = 2, bezier = "default" })
hl.animation({ leaf = "fade", enabled = true, speed = 2, bezier = "default" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 2, bezier = "default" })

hl.device({
    name = "epic-mouse-v1",
    sensitivity = -0.5,
})
hl.window_rule({
    name = "red-border-for-fullscreen",
    match = { fullscreen = true },
    border_color = {
        colors = {
            "#FF0000",
            "#880808",
        },
    },
})

local mainMod = "SUPER"

hl.bind(mainMod .. " + Return", hl.dsp.exec_cmd("wofi --show drun"))
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd("wofi-emoji"))
hl.bind(mainMod .. " + T", hl.dsp.exec_cmd("alacritty"))
hl.bind("ALT + F4", hl.dsp.window.kill())
hl.bind(mainMod .. " + ALT + Escape", hl.dsp.exit()) -- TODO recommended to use hyprshutdown
hl.bind(mainMod .. " + V", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + P", hl.dsp.exec_cmd("hyprpicker --autocopy"))
hl.bind(mainMod .. " + SHIFT + P", hl.dsp.window.pin())
hl.bind(mainMod .. " + C", hl.dsp.window.center())

for i = 1, 10 do
    hl.bind(mainMod .. " + " .. tostring(i % 10), hl.dsp.focus({ workspace = i }))
    hl.bind(mainMod .. " + SHIFT + " .. tostring(i % 10), hl.dsp.window.move({ workspace = i }))
end

hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag())
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize())

hl.bind(mainMod .. " + W", hl.dsp.focus({ direction = "l" }))
hl.bind(mainMod .. " + A", hl.dsp.focus({ direction = "u" }))
hl.bind(mainMod .. " + S", hl.dsp.focus({ direction = "d" }))
hl.bind(mainMod .. " + D", hl.dsp.focus({ direction = "r" }))
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen({ action = "toggle" }))
hl.bind(mainMod .. " + SHIFT + F", hl.dsp.window.fullscreen({ mode = "maximized", action = "toggle" }))

hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%+"))
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"))
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"))
