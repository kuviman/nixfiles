{ pkgs, inputs, ... }:

{
  # List packages installed in system profile. To search, run:
  # $ nix search wget # LOL ok but how can I make it work?
  environment.systemPackages = with pkgs; [
    firefox # Browsing the web 
    google-chrome # Another way of browsing the web
    tdesktop # Telegram
    hexchat # Irc
    discord # Discord
    wofi # like rofi - app runner for wayland
    wl-clipboard # wl-copy, wl-paste, required for clipboard to work in neovim
    ffmpeg-full # has ffplay
    piper # for Logitech G Pro
    pavucontrol # Gui for controlling audio
    waybar # Wayland bar
    swaylock # Wayland lock
    hyprpaper # Background image
    hyprpicker # Pick color from screen
    wofi-emoji # emoji picker
    steam # GAMES
    wineWowPackages.waylandFull # run windows apps
    ntfs3g # to break windows from linux YEP
    glxinfo # To test which opengl version I have
    psutils
    psmisc # fuser
    python3 # calculator
    zoom-us
    xorg.xeyes
    vlc

    prismlauncher
    minecraft

    # Command line
    gh # github
    git # gud
    git-lfs
    lazygit # Better git?
    gitui # Better lazygit?
    exa # ls++
    bat # cat++
    alacritty # terminal
    just # just command runner
    curl # pretty sure its installed by default but anyway
    wget # Downloading things from command line
    neofetch # BTW
    tokei # Scan project languages and lines of code
    ripgrep # Grep the rip
    fd # User-friendly find
    unzip
    zip
    moreutils # sponge
    libguestfs-with-appliance

    age # encryption
    sops # secrets

    # Coding
    bacon # Background rust code checker
    rust-analyzer
    taplo # toml language server
    marksman # markdown language server
    lldb # debug
    lua-language-server
    nil # nix language server
    nixpkgs-fmt # nix formatter
    butler # for itch.io
    zola # static site generator

    # Monitoring
    # top already installed
    bottom
    htop
    glances # This is what I actually use

    # Probably unused should try some out maybe
    helix # For when I'm done with neovim
    kitty # Default on hyprland, can remove?
    nushell # For when I'm done with zsh
    # vscode # If I can't figure out neovim
    # vscode.fhs
    vscode-fhs
    brightnessctl # TODO try on laptop
    linux-wifi-hotspot # Nertsal uses that
    cava # Audio visualizer
    cmatrix # Matrix visualizer
    xh # better curl?
    xxh # Bring your shell through ssh
    erdtree # File-tree visualizer and disk usage analyzer
    dua # disk usage analyzer
    felix-fm # Tui file manager
    topgrade # Update everything
    kondo # Cleaner after you upgrade everything
    any-nix-shell # Keep shell when in nix-shell (nix-shell is outdated tho so I should use smth else?)

    # Drawing
    inkscape
    aseprite-unfree
    gimp
    krita
    blender
    # glaxnimate
    synfigstudio

    kdenlive # video editing
    audacity # for fish sound effects
    ldtk # for linksider

    # screenshots
    grim # backend
    flameshot
    slurp
    gscreenshot

    (
      let
        crane =
          inputs.geng.lib.x86_64-linux.crane;
      in
      crane.buildPackage {
        src = builtins.fetchGit {
          url = "https://github.com/KunalBagaria/rustyvibes.git";
          ref = "main";
          rev = "f19fdf961ae602122ed7a2b95f570be0def79c34";
        };
        buildInputs = [
          pkg-config
          alsa-lib
          xorg.libX11
          xorg.libXi
          xorg.libXtst
        ];
        cargoVendorDir = crane.vendorCargoDeps { cargoLock = ../rustyvibes.Cargo.lock; };
      }
    )
  ];
  services.ratbagd.enable = true; # for piper

  fonts.packages = with pkgs; [
    (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
  ];

  services.upower.enable = true; # checking wireless mouse power for example

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
}
