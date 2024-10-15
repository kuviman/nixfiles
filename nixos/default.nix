{ inputs }:

let
  self = inputs.self;
  nixpkgs = inputs.nixpkgs;
  system = "x86_64-linux";
  mkOs = hostname:
    nixpkgs.lib.nixosSystem {
      # Pass flake inputs to our config
      specialArgs = { inherit inputs hostname system; };
      # > Our main nixos configuration file <
      modules = [
        ./nixos/configuration.nix
        {
          system.configurationRevision = nixpkgs.lib.mkIf (self ? rev) self.rev;
        }
      ];
    };
in
{
  mainix = mkOs "mainix";
  swiftix = mkOs "swiftix";
}
