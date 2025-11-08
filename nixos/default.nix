{ inputs }:

let
  self = inputs.self;
  nixpkgs = inputs.nixpkgs-stable;
  system = "x86_64-linux";
  pkgs = import nixpkgs { inherit system; };
  lib = pkgs.lib;
  pkgs-unstable = import inputs.nixpkgs-unstable { inherit system; };
  mkOs = hostname: config:
    nixpkgs.lib.nixosSystem {
      # Pass flake inputs to our config
      specialArgs = { inherit inputs hostname system self pkgs-unstable; };
      # > Our main nixos configuration file <
      modules = [
        ./configuration.nix
        config
        {
          system.configurationRevision = nixpkgs.lib.mkIf (self ? rev) self.rev;
          nixpkgs.overlays = [ ];
        }
        ./machines/_common.nix
      ];
    };
  machines =
    let machine-files = builtins.readDir ./machines; in
    builtins.map (name: lib.removeSuffix ".nix" name)
      (builtins.filter
        (name: lib.hasSuffix ".nix" name && !(lib.hasPrefix "_" name))
        (builtins.attrNames machine-files));
in
builtins.listToAttrs
  (
    builtins.map
      (name: {
        inherit name;
        value = mkOs name (import ./machines/${name}.nix);
      })
      machines
  )
