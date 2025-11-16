{ config, inputs, pkgs-unstable, ... }:
{
  imports = [
    inputs.niri.homeModules.niri
    inputs.dankMaterialShell.homeModules.dankMaterialShell.default
    inputs.dankMaterialShell.homeModules.dankMaterialShell.niri
  ];
  programs.niri = {
    package = pkgs-unstable.niri;
    settings = {
      input.mouse = {
        accel-speed = -0.2;
        accel-profile = "flat";
      };
      outputs = {
        "DP-2".position = { x = 0; y = 0; };
        "HDMI-A-1".position = {
          x = 2560;
          y = 180;
        };
      };
      layout.struts.right = 590;
      binds = with config.lib.niri.actions; let
        playerctl = spawn "${pkgs-unstable.playerctl}/bin/playerctl";
        dms-ipc = spawn "dms" "ipc";
      in
      {
        "Mod+Shift+Slash".action = show-hotkey-overlay;

        "XF86AudioPlay".action = playerctl "play-pause";
        "XF86AudioStop".action = playerctl "pause";
        "XF86AudioPrev".action = playerctl "previous";
        "XF86AudioNext".action = playerctl "next";

        "Print".action.screenshot-screen = { write-to-disk = true; };
        "Mod+Shift+Alt+S".action.screenshot-window = [ ];
        "Mod+Shift+S".action.screenshot = { show-pointer = false; };
        "Mod+T".action = spawn "alacritty";

        "Mod+Q".action = close-window;
        "Mod+S".action = switch-preset-column-width;
        "Mod+F".action = maximize-column;

        "Mod+1".action = set-column-width "25%";
        "Mod+2".action = set-column-width "50%";
        "Mod+3".action = set-column-width "75%";
        "Mod+4".action = set-column-width "100%";
        "Mod+Shift+F".action = fullscreen-window;
        # "Mod+Shift+F".action = expand-column-to-available-width;
        "Mod+V".action = toggle-window-floating;
        "Mod+W".action = toggle-column-tabbed-display;

        "Mod+C".action = center-visible-columns;
        "Mod+Tab".action = switch-focus-between-floating-and-tiling;

        "Mod+Minus".action = set-column-width "-10%";
        "Mod+Plus".action = set-column-width "+10%";
        "Mod+Shift+Minus".action = set-window-height "-10%";
        "Mod+Shift+Plus".action = set-window-height "+10%";

        "Mod+H".action = focus-column-left;
        "Mod+L".action = focus-column-right;
        "Mod+J".action = focus-window-or-workspace-down;
        "Mod+K".action = focus-window-or-workspace-up;
        "Mod+Left".action = focus-column-left;
        "Mod+Right".action = focus-column-right;
        "Mod+Down".action = focus-workspace-down;
        "Mod+Up".action = focus-workspace-up;

        "Mod+Shift+H".action = move-column-left;
        "Mod+Shift+L".action = move-column-right;
        "Mod+Shift+K".action = move-column-to-workspace-up;
        "Mod+Shift+J".action = move-column-to-workspace-down;

        "Mod+O".action = toggle-overview;
        "Mod+D" = {
          action = dms-ipc "spotlight" "toggle";
          hotkey-overlay.title = "Toggle Application Launcher";
        };
        "Mod+N" = {
          action = dms-ipc "notifications" "toggle";
          hotkey-overlay.title = "Toggle Notification Center";
        };
        "Mod+Comma" = {
          action = dms-ipc "settings" "toggle";
          hotkey-overlay.title = "Toggle Settings";
        };
        "Mod+P" = {
          action = dms-ipc "notepad" "toggle";
          hotkey-overlay.title = "Toggle Notepad";
        };
        "Super+Alt+L" = {
          action = dms-ipc "lock" "lock";
          hotkey-overlay.title = "Toggle Lock Screen";
        };
        "Mod+X" = {
          action = dms-ipc "powermenu" "toggle";
          hotkey-overlay.title = "Toggle Power Menu";
        };
        "XF86AudioRaiseVolume" = {
          allow-when-locked = true;
          action = dms-ipc "audio" "increment" "3";
        };
        "XF86AudioLowerVolume" = {
          allow-when-locked = true;
          action = dms-ipc "audio" "decrement" "3";
        };
        "XF86AudioMute" = {
          allow-when-locked = true;
          action = dms-ipc "audio" "mute";
        };
        "XF86AudioMicMute" = {
          allow-when-locked = true;
          action = dms-ipc "audio" "micmute";
        };
        "Mod+Alt+N" = {
          allow-when-locked = true;
          action = dms-ipc "night" "toggle";
          hotkey-overlay.title = "Toggle Night Mode";
        };
        "Mod+M" = {
          action = dms-ipc "processlist" "toggle";
          hotkey-overlay.title = "Toggle Process List";
        };
        "Mod+Period" = {
          action = dms-ipc "clipboard" "toggle";
          hotkey-overlay.title = "Toggle Clipboard Manager";
        };
        "XF86MonBrightnessUp" = {
          allow-when-locked = true;
          action = dms-ipc "brightness" "increment" "5" "";
        };
        "XF86MonBrightnessDown" = {
          allow-when-locked = true;
          action = dms-ipc "brightness" "decrement" "5" "";
        };
      };
    };
  };
  programs.dankMaterialShell = {
    enable = true;
    niri = {
      # enableKeybinds = true;
      enableSpawn = true;
    };
    default.settings = {
      theme = "dark";
      dynamicTheming = true;
      # Add any other settings here
    };
    default.session = {
      # Session state defaults
    };
    quickshell.package = pkgs-unstable.quickshell;

    systemd = {
      enable = true; # Systemd service for auto-start
      restartIfChanged = true; # Auto-restart dms.service when dankMaterialShell changes
    };

    # Core features
    enableSystemMonitoring = true; # System monitoring widgets (dgop)
    enableClipboard = true; # Clipboard history manager
    enableVPN = true; # VPN management widget
    enableBrightnessControl = true; # Backlight/brightness controls
    enableColorPicker = true; # Color picker tool
    enableDynamicTheming = true; # Wallpaper-based theming (matugen)
    enableAudioWavelength = true; # Audio visualizer (cava)
    enableCalendarEvents = true; # Calendar integration (khal)
    enableSystemSound = true; # System sound effects
  };
}
