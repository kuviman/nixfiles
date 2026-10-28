# { config, pkgs, username, hostname, ... }:
{ config, lib, pkgs, hostname, ... }:

{
  imports = [
    ./hyprland
    # ./niri
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
    home.stateVersion = "26.05"; # Please read the comment before changing.

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

    home.packages = [
      (pkgs.writeShellApplication {
        name = "make-gif";
        text = ''
          input="$1"
          width="$2"
          output="$3"

          RANGE=()
          if [ "$#" -ge 4 ]; then
            RANGE=("-ss" "$4" "-to" "$5")
          fi
          
          ffmpeg "''${RANGE[@]}" -i "$input" -filter_complex  "fps=15,scale=$width:-2,palettegen=stats_mode=full" /tmp/gif_palette.png -y
          ffmpeg "''${RANGE[@]}" -i "$input" -i /tmp/gif_palette.png -filter_complex "[0]fps=15,scale=$width:-2[scaled];[scaled][1]paletteuse=dither=sierra2_4a" "$output" -y
        '';
      })
    ];

    home.file = {
      ".config/nixpkgs/config.nix".text = ''
        { allowUnfree = true; }
      '';

      ".config/helix".source = ./helix;
      ".config/neovide".source = ./neovide;
      ".config/lazygit/config.yml".source = ./lazygit/config.yml;
    };

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
        github = "${pkgs.gh}/bin/gh";
      };
      initContent = lib.mkMerge [
        ''
          PS1='%(?.%F{green}.%F{red})$%b%f '
        ''
        (lib.mkOrder 2000 (builtins.readFile ./vscode-direnv-fix.zsh))
      ];
      oh-my-zsh = {
        enable = true;
        plugins = [ "git" "sudo" ];
      };
    };

    programs.nnn.quitcd = true;

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
