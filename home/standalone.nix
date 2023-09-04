{ config, username, ... }: {
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Home Manager needs a bit of information about you and the paths it should manage.
  home = {
    username = username;
    homeDirectory = "/home/${username}";
  };
}
