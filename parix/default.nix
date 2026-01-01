{ lib, pkgs, inputs, ... }:

{
  imports =
    [
      inputs.disko.nixosModules.disko
      ./disko.nix
      ./hardware-configuration.nix
    ];
  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      auto-optimise-store = true;
      trusted-users = [ "root" "@wheel" ];
    };
  };
  boot.loader.grub = {
    enable = true;
  };
  networking.hostName = "parix";
  # Set your time zone.
  # time.timeZone = "Europe/Amsterdam";
  users = {
    mutableUsers = false;
    users = {
      kuviman = {
        isNormalUser = true;
        extraGroups = [ "wheel" "docker" ];
        hashedPassword = "$6$sJIicuxpMxWEajk4$yrECTQD0MIYgtmTDseQCFeU04cW/9CSEJoDVsxD1A5RcjC7v5bfGVx9wiaXB20c8Vf9bmi4jFbgh3HWu41F6G1";
        openssh.authorizedKeys.keys = [
          "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDYhCnHEd0oBaXVJpv48s0jrlomRvw958+oZCdXape7sLOPAXX5NdRrHyFvSXe47CzaT3IPLXZ+lkjKcMcFA02d0YgaluOuEAIJZK6QHM5B1KHqbIEjV+gAkFq+ss25S5TgpD4Q0YHa4MGSwRQ44NWv0Lx2kROjYHCqkt93Thf3b81libQwI6Ige1rDd0O7BNqRQ4+UIUTLSX+bn4oo3wfgpoE2I0YuZGfRT/HzYpccbF3jfmvA3nZq3eHLXGK+qPc86cHLtVYH8Ltlovrwntgj/MIaRzRV2JDNnlrEJCYM54j2VlJWYmyHjCrtYYyGcZ7o/4mLzGb2pFQcdrsgxfkvMjcwRzntw0iYNi00yaUQdpY3D+6lPq+mUOuuvlOLOwKGMZKRTs0HYyzrHrqvjQBlL+AaQQcdbbtZF7lTJxGByY1vMqZpLQMQOcD3TP8mBDtiFNlW+mT/NBf8slFB5vKnfNlQfa7LyYLlTYGjAwofNIDNC4Dhs113Jx7Fx7wVYCE= kuviman@mainix"
        ];
      };
    };
  };
  virtualisation.docker.enable = true;
  environment.systemPackages = with pkgs; [
    vim
    wget
  ];
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = lib.mkForce "prohibit-password";
    };
  };

  boot.initrd = {
    compressor = "zstd";
    compressorArgs = [ "-19" "-T0" ];
    systemd.enable = true;
  };
  # https://lantian.pub/en/article/modify-computer/nixos-low-ram-vps.lantian/
  boot.kernelParams = [ "audit=0" "net.ifnames=0" ];
  systemd.network = {
    enable = true;
    networks.eth0 = {
      address = [ "166.88.228.159/24" ];
      gateway = [ "166.88.228.1" ];
      matchConfig.Name = "eth0";
    };
  };
  services.resolved.enable = false;
  networking = {
    useDHCP = false;
    firewall = {
      enable = false;
      allowedTCPPorts = [ ];
      allowedUDPPorts = [ ];
    };
    nameservers = [ "8.8.8.8" ];
  };
  system.stateVersion = "25.11";
  services.caddy = {
    enable = true;
    virtualHosts."paris.kuviman.com".extraConfig = ''
      reverse_proxy http://localhost:2053
    '';
  };
}

