{ inputs }:


let
  mkHome = username: hostname:
    let system = "x86_64-linux"; in
    inputs.home-manager.lib.homeManagerConfiguration
      {
        pkgs = inputs.nixpkgs.legacyPackages.${system}; # Home-manager requires 'pkgs' instance
        # Pass flake inputs to our config
        extraSpecialArgs = { inherit inputs username hostname; };
        # > Our main home-manager configuration file <
        modules = [
          (./home + ("/" + username + ".nix"))
          ./home/standalone.nix
          ./home/home.nix
        ];
      };
in
{
  "kuviman@mainix" = mkHome "kuviman" "mainix";
  "kuviman@swiftix" = mkHome "kuviman" "swiftix";
}
