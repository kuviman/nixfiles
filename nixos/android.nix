{ config, pkgs, ... }:

{
  users.users.${config.nixfiles.username}.extraGroups = [ "adbusers" ];
  environment.systemPackages = with pkgs; [
    scrcpy
    jmtpfs
    android-tools
  ];
}
