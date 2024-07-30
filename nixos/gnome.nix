{ pkgs, ... }:

{
  services.xserver.desktopManager.gnome.enable = true;
  environment.systemPackages =
    with pkgs;
    let
      extensions = with gnomeExtensions; [
        compiz-windows-effect
        tray-icons-reloaded
        unite
        wireless-hid
        wifi-qrcode
        weeks-start-on-monday-again
        vitals
        burn-my-windows
        forge
        paperwm
      ];
    in
    extensions ++ [ gnome-tweaks ];
  environment.gnome.excludePackages = (with pkgs; [
    gnome-photos
    gnome-tour
    cheese # webcam tool
    gnome-terminal
    epiphany # web browser
    geary # email reader
    evince # document viewer
    totem # video player
  ]) ++ (with pkgs.gnome; [
    gnome-music
    pkgs.gedit # text editor
    gnome-characters
    tali # poker game
    iagno # go game
    hitori # sudoku game
    atomix # puzzle game
  ]);
}
