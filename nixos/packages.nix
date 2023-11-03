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
    wl-clipboard # wl-copy, wl-paste, required for clipboard to work in neovim
    ffmpeg-full # has ffplay
    piper # for Logitech G Pro
    python3 # calculator
    zoom-us
    vlc
    remmina # RDP

    prismlauncher # minecraft
    steam # GAMES
    steam-run # windows games
    lutris # More GAMES
    wineWowPackages.waylandFull # run windows apps

    # Command line
    gh # github
    git # gud
    git-lfs # I don't actually use that
    lazygit # Better git?
    eza # ls++
    bat # cat++
    alacritty # terminal
    curl # pretty sure its installed by default but anyway
    wget # Downloading things from command line
    neofetch # BTW
    tokei # Scan project languages and lines of code
    ripgrep # Grep the rip
    fd # User-friendly find
    unzip
    zip
    moreutils # sponge
    psmisc # fuser
    psutils
    ntfs3g # to break windows from linux YEP
    libguestfs-with-appliance # to mount hyper-v vm data
    file

    age # encryption
    sops # secrets
    yt-dlp # download YouTube
    twitch-dl # download Twitch

    nil # nix language server
    nixpkgs-fmt # nix formatter

    glances # System monitoring

    helix # For when I'm done with neovim
    vscode-fhs
    dua # disk usage analyzer
    any-nix-shell # Keep shell when in nix-shell (nix-shell is outdated tho so I should use smth else?)

    # Drawing
    inkscape
    aseprite-unfree
    blender

    kdenlive # video editing
    audacity # for fish sound effects

    daktilo # fake keyboard sounds
  ];
  services.ratbagd.enable = true; # for piper

  fonts.packages = with pkgs; [
    (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
  ];

  services.upower.enable = true; # checking wireless mouse power for example

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
}
