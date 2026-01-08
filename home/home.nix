# { config, pkgs, username, hostname, ... }:
{ config, lib, pkgs, hostname, ... }:

{
  imports = [
    ./hyprland
    # ./niri
    ./nnn
    ./cursor.nix
  ];

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

      ".config/helix".source = ./helix;
      ".config/neovide".source = ./neovide;
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
      settings = {
        user = {
          name = config.home.username;
          email = (builtins.elemAt (lib.filter (a: a.primary) (builtins.attrValues config.accounts.email.accounts)) 0).address;
        };
        init.defaultBranch = "main";
      };
      lfs.enable = true;
    };

    # TODO idk what it does really
    # Nicely reload system units when changing configs
    systemd.user.startServices = "sd-switch";

    programs.zsh = {
      enable = true;
      autosuggestion.enable = true;
      enableCompletion = true;
      syntaxHighlighting.enable = true;
      enableVteIntegration = true;
      shellAliases = {
        nixos = "sudo nixos-rebuild --flake $HOME/nixfiles";
        l = "eza --long --icons=always";
        ls = "eza --icons=always";
        lt = "eza --tree --icons=always";
        cargo-patched = "cargo --config $HOME/.cargo/patched.toml";
        calculator = "${pkgs.nodejs}/bin/node";
      };
      initContent = ''
        PS1='%(?.%F{green}.%F{red})$%b%f '
      '';
      profileExtra = (builtins.readFile ./vscode-direnv-fix.zsh);
      oh-my-zsh = {
        enable = true;
        plugins = [ "git" "sudo" ];
      };
    };

    programs.nnn.quitcd.enable = true;

    programs.alacritty = {
      enable = true;
      settings = {
        font = {
          normal = {
            family = "MonaspiceKr Nerd Font";
            style = "Regular";
          };
          bold = {
            family = "MonaspiceKr Nerd Font";
            style = "Bold";
          };
          italic = {
            family = "MonaspiceKr Nerd Font";
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
      silent = true;
    };
  };
}
