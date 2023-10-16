# { config, pkgs, username, hostname, ... }:
{ config, lib, pkgs, hostname, ... }:

{
  imports = [ ];

  options = {
    email = lib.mkOption {
      type = with lib.types; str;
      description = "User email";
    };
  };
  config = {
    # This value determines the Home Manager release that your configuration is
    # compatible with. This helps avoid breakage when a new Home Manager release
    # introduces backwards incompatible changes.
    #
    # You should not change this value, even if you update Home Manager. If you do
    # want to update the value, then make sure to first check the Home Manager
    # release notes.
    home.stateVersion = "22.11"; # Please read the comment before changing.

    accounts.email.accounts = {
      primary = {
        primary = true;
        address = config.email;
      };
    };

    nixpkgs = {
      # You can add overlays here
      overlays = [
        # If you want to use overlays exported from other flakes:
        # neovim-nightly-overlay.overlays.default

        # Or define it inline, for example:
        # (final: prev: {
        #   hi = final.hello.overrideAttrs (oldAttrs: {
        #     patches = [ ./change-hello-to-hi.patch ];
        #   });
        # })
      ];
      # Configure your nixpkgs instance
      config = {
        # Disable if you don't want unfree packages
        allowUnfree = true;
        # Workaround for https://github.com/nix-community/home-manager/issues/2942
        allowUnfreePredicate = (_: true);
      };
    };

    # The home.packages option allows you to install Nix packages into your
    # environment.
    # BUT I'M NOT USING THAT
    home.packages = [
      # # Adds the 'hello' command to your environment. It prints a friendly
      # # "Hello, world!" when run.
      # pkgs.hello

      # # It is sometimes useful to fine-tune packages, for example, by applying
      # # overrides. You can do that directly here, just don't forget the
      # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
      # # fonts?
      # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

      # # You can also create simple shell scripts directly inside your
      # # configuration. For example, this adds a command 'my-hello' to your
      # # environment:
      # (pkgs.writeShellScriptBin "my-hello" ''
      #   echo "Hello, ${config.home.username}!"
      # '')
    ];

    # Home Manager is pretty good at managing dotfiles. The primary way to manage
    # plain files is through 'home.file'.
    home.file = {
      ".config/nixpkgs/config.nix".text = ''
        { allowUnfree = true; }
      '';

      ".config/hypr/hyprpaper.conf".text =
        let wallpaper = pkgs.nixos-artwork.wallpapers.simple-dark-gray.gnomeFilePath;
        in ''
          preload = ${wallpaper}
          wallpaper = ,${wallpaper}
          ipc = off
          splash = false
        '';

      ".config/hypr/hyprland.conf".text =
        let
          monitors =
            if (hostname == "mainix") then ''
              monitor=DP-2,2560x1440@144,0x0,1
              monitor=HDMI-A-1,1920x1080@60,2560x180,1
              workspace=1, monitor:DP-2
              workspace=2, monitor:DP-2
              workspace=3, monitor:DP-2
              workspace=4, monitor:DP-2
              workspace=5, monitor:DP-2
              workspace=6, monitor:DP-2
              workspace=7, monitor:DP-2
              workspace=8, monitor:HDMI-A-1
              workspace=9, monitor:HDMI-A-1
              workspace=10, monitor:HDMI-A-1
            ''
            else if (hostname == "swiftix") then ''
              monitor=eDP-1,preferred,auto,1
            ''
            else "";
        in
        monitors + builtins.readFile ./hyprland.conf;
      # TODO ".config/hypr/hyprpaper.conf".source = ./hyprpaper.conf;
      ".config/waybar".source = ./waybar;
      ".config/wofi".source = ./wofi;
      ".config/helix".source = ./helix;
    };

    # You can also manage environment variables but you will have to manually
    # source
    #
    #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
    #
    # or
    #
    #  /etc/profiles/per-user/kuviman/etc/profile.d/hm-session-vars.sh
    #
    # if you don't want to manage your shell through Home Manager.
    home.sessionVariables = {
      SHELL = "zsh";
      EDITOR = "nvim";
    };

    programs.git = {
      enable = true;
      userName = config.home.username;
      userEmail = (builtins.elemAt (lib.filter (a: a.primary) (builtins.attrValues config.accounts.email.accounts)) 0).address;
      extraConfig = {
        init.defaultBranch = "main";
      };
      lfs.enable = true;
    };

    # TODO idk what it does really
    # Nicely reload system units when changing configs
    systemd.user.startServices = "sd-switch";

    programs.zsh = {
      enable = true;
      enableAutosuggestions = true;
      enableCompletion = true;
      syntaxHighlighting.enable = true;
      enableVteIntegration = true;
      shellAliases = {
        nixos = "sudo nixos-rebuild --flake $HOME/nixfiles";
        l = "eza --long --icons";
        ls = "eza --icons";
        lt = "eza --tree --icons";
        cargo-patched = "cargo --config $HOME/.cargo/patched.toml";
      };
      initExtra = ''
        PS1='%(?.%F{green}.%F{red})$%b%f '
      '';
    };

    programs.alacritty = {
      enable = true;
      settings = {
        font = {
          normal = {
            family = "JetBrainsMono Nerd Font";
            style = "Regular";
          };
          bold = {
            family = "JetBrainsMono Nerd Font";
            style = "Bold";
          };
          italic = {
            family = "JetBrainsMono Nerd Font";
            style = "Italic";
          };
          size = 16;
        };
        window = {
          opacity = 0.95;
          decorations = "none";
        };
      };
    };

    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    home.pointerCursor = {
      x11.enable = true;
      gtk.enable = true;
      package = pkgs.catppuccin-cursors.macchiatoPink;
      name = "Catppuccin-Macchiato-Pink-Cursors";
      size = 128;
    };
  };
}
