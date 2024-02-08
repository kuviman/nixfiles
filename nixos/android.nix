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
}
