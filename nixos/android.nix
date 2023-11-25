{ pkgs, ... }:

{
  programs.adb.enable = true;
  users.users.kuviman.extraGroups = [ "adbusers" ];
  environment.systemPackages = with pkgs; [
    android-udev-rules
    scrcpy
    jmtpfs
    android-studio
  ];
  # https://github.com/M0Rf30/android-udev-rules/issues/287
  nixpkgs.overlays = [
    (final: prev: {
      android-udev-rules = prev.android-udev-rules.overrideAttrs rec {
        version = "20231124";
        src = pkgs.fetchFromGitHub {
          owner = "M0Rf30";
          repo = "android-udev-rules";
          rev = version;
          # nixpkgs uses sha256= instead of hash= which makes it behave ultra weird???
          hash = "sha256-pDAAC8RibPtkhVVz5WPj/eUjz0A+8bZt/pjzG8zpaE4=";
        };
      };
    })
  ];
}
