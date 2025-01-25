{ system, inputs, pkgs, lib, config, hostname, ... }:

{
  # for l2tp vpn - https://github.com/NixOS/nixpkgs/issues/64965#issuecomment-741920446
  services.strongswan = {
    enable = true;
    secrets = [
      "ipsec.d/ipsec.nm-l2tp.secrets"
    ];
  };
  services.v2raya = {
    enable = true;
    cliPackage = pkgs.xray;
  };
}
