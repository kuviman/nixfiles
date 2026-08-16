{ pkgs, ... }:

let
  wireproxy-awg =
    pkgs.wireproxy.overrideAttrs (finalAttrs: oldAttrs: {
      version = "1.0.17";
      src = pkgs.fetchFromGitHub {
        owner = "artem-russkikh";
        repo = "wireproxy-awg";
        rev = "v${finalAttrs.version}";
        hash = "sha256-nxzgEg8SKkrYXOLu4ikCkmaCZB6pYHdSTYAiWmv0TfM=";
      };
      vendorHash = "sha256-95Gjh5bD3TGLgAALLyVV27zmxTGSqGK7bvYS9UaTGmE=";
    });
in

{
  # for l2tp vpn - https://github.com/NixOS/nixpkgs/issues/64965#issuecomment-741920446
  services.strongswan = {
    enable = true;
    secrets = [
      "ipsec.d/ipsec.nm-l2tp.secrets"
    ];
  };
  programs.amnezia-vpn = {
    enable = true;
  };
  environment.systemPackages = [ wireproxy-awg ];
  services.v2raya = {
    enable = true;
    cliPackage = pkgs.xray;
  };
}
