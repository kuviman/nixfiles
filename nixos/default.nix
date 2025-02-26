{ inputs }:

let
  self = inputs.self;
  nixpkgs = inputs.nixpkgs;
  system = "x86_64-linux";
  pkgs-unstable = import inputs.nixpkgs-unstable { inherit system; };
  mkOs = hostname:
    nixpkgs.lib.nixosSystem {
      # Pass flake inputs to our config
      specialArgs = { inherit inputs hostname system self pkgs-unstable; };
      # > Our main nixos configuration file <
      modules = [
        ./configuration.nix
        {
          system.configurationRevision = nixpkgs.lib.mkIf (self ? rev) self.rev;
          nixpkgs.overlays = [ inputs.hyprpanel.overlay ];
        }
      ];
    };
in
{
  mainix = mkOs "mainix";
  swiftix = mkOs "swiftix";
}
