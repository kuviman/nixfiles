{ pkgs, ... }:

{
  services.xserver.desktopManager.gnome.enable = true;
  environment.systemPackages =
    with pkgs;
    let
      extensions = with gnomeExtensions; [
        tray-icons-reloaded
        unite
        wireless-hid
        wifi-qrcode
        weeks-start-on-monday-again
        vitals
        eye-extended
        burn-my-windows
        activate_gnome
        pop-shell
        workspace-matrix
        forge
      ];
    in
    extensions ++ [ gnome.gnome-tweaks ];
  environment.gnome.excludePackages = (with pkgs; [
    gnome-photos
    gnome-tour
  ]) ++ (with pkgs.gnome; [
    cheese # webcam tool
    gnome-music
    gnome-terminal
    pkgs.gedit # text editor
    epiphany # web browser
    geary # email reader
    evince # document viewer
    gnome-characters
    totem # video player
    tali # poker game
    iagno # go game
    hitori # sudoku game
    atomix # puzzle game
  ]);
}
