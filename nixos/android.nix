{ config, pkgs, ... }:

{
  programs.adb.enable = true;
  users.users.${config.nixfiles.username}.extraGroups = [ "adbusers" ];
  environment.systemPackages = with pkgs; [
    scrcpy
    jmtpfs
  ];
}
