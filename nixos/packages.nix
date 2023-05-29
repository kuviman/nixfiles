{ pkgs, ... }:

{
  # List packages installed in system profile. To search, run:
  # $ nix search wget # LOL ok but how can I make it work?
  environment.systemPackages = with pkgs; [
    firefox # Browsing the web 
    tdesktop # Telegram
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
    steam # GAMES
    ntfs3g # to break windows for linux YEP
    glxinfo # To test which opengl version I have

    # Command line
    git # gud
    lazygit # Better git?
    gitui # Better lazygit?
    lsd # ls++
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

    # Coding
    bacon # Background rust code checker
    rust-analyzer
    lua-language-server
    nil # nix language server
    butler # for itch.io

    # Monitoring
    # top already installed
    bottom
    htop
    glances # This is what I actually use

    # Probably unused should try some out maybe
    helix # For when I'm done with neovim
    kitty # Default on hyprland, can remove?
    nushell # For when I'm done with zsh
    vscode # If I can't figure out neovim
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
    gimp
    krita
    blender
    # glaxnimate
    synfigstudio

    kdenlive # video editing
    audacity # for fish sound effects

    # screenshots
    grim # backend
    flameshot
    slurp
    gscreenshot
  ];
  services.ratbagd.enable = true; # for piper

  fonts.fonts = with pkgs; [
    (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
  ];

  services.upower.enable = true; # checking wireless mouse power for example

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
}
