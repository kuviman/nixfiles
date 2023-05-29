{ ... }:

{
  programs.adb.enable = true;
  users.users.kuviman.extraGroups = [ "adbusers" ];
}
