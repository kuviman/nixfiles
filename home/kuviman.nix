{ config, pkgs, inputs, system, ... }: {
  email = "kuviman@gmail.com";

  systemd.user.services = {
    ttv =
      let
        ttv-bin = inputs.ttv.defaultApp.${system};
        workDir = config.home.homeDirectory + "/.ttv";
      in
      {
        Unit = {
          Description = "Twitch Stuff";
          After = [ "network.target" ];
        };

        Install = {
          WantedBy = [ "default.target" ];
        };

        Service = {
          Type = "simple";
          WorkingDirectory = workDir;
          ExecStart = "${ttv-bin.program} --server 0.0.0.0:1789";
          Restart = "always";
          RestartSec = "10";
        };
      };
    ttv-web = {
      Unit = {
        Description = "Twitch Stuff (Frontend serving)";
        After = [ "network.target" ];
      };

      Install = {
        WantedBy = [ "default.target" ];
      };

      Service = {
        Type = "simple";
        ExecStart = "${pkgs.caddy}/bin/caddy file-server --listen :1788 --root ${inputs.ttv.web}";
        Restart = "always";
        RestartSec = "10";
      };
    };
  };
}
