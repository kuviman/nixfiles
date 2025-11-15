{ config, hostname, pkgs, inputs, system, ... }: {
  email = "kuviman@gmail.com";

  programs.zsh.shellAliases = {
    streamer-mode = "hyprctl keyword monitor DP-2,addreserved,0,0,0,580";
  };
  systemd.user.services =
    pkgs.lib.mkIf (hostname == "mainix") {
      kuvibot = {
        Unit = {
          Description = "twitch bot";
          After = [ "network.target" ];
        };

        Install = {
          WantedBy = [ "default.target" ];
        };

        Service = {
          Type = "simple";
          WorkingDirectory = config.home.homeDirectory + "/.kuvibot";
          # ExecStart = "${inputs.kuvibot.apps.${system}.kuviboy.program}";
          ExecStart = "${inputs.kuvibot.apps.${system}.kuviman.program}";
          Restart = "always";
          RestartSec = "10";
        };
      };
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

        Service =
          let
            caddyfile = pkgs.writeText "Caddyfile" ''
              :1787
              header Cache-Control no-store
              root * ${inputs.ttv.web}
              file_server
            '';
          in
          {
            Type = "simple";
            ExecStart = "${pkgs.caddy}/bin/caddy run --config ${caddyfile} --adapter caddyfile";
            Restart = "always";
            RestartSec = "10";
          };
      };
    };
}
