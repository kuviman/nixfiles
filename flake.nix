{
  inputs = {
    # Nixpkgs
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.11";
    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs-stable";
  };

  outputs = inputs:
    {
      nixosConfigurations = {
        parix = inputs.nixpkgs-stable.lib.nixosSystem {
          specialArgs = { inherit inputs; };
          modules = [
            ./parix
          ];
        };
      };
    };
}
