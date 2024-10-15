{
  description = "Kuvi Man nix configs";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-xray-pr.url = "github:iopq/nixpkgs/patch-1";

    # Secrets
    sops.url = "github:Mic92/sops-nix";
    # Home manager
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    ttv.url = "github:kuviman/ttv";
    kuvibot.url = "github:kuviman/kuvibot";

    aylur-dotfiles.url = "github:Aylur/dotfiles";

    # Fixes 404 error downloading this dependency
    astal.url = "github:Aylur/astal";
    aylur-dotfiles.inputs.astal.follows = "astal";

    systems.url = "github:nix-systems/default";

    # TODO: take a look at this:
    # Shameless plug: looking for a way to nixify your themes and make
    # everything match nicely? Try nix-colors!
    # nix-colors.url = "github:misterio77/nix-colors";
  };

  outputs = { self, ... }@inputs:
    {
      lib = import ./lib { inherit inputs; };

      # NixOS configuration entrypoint
      # Available through 'nixos-rebuild --flake .#your-hostname'
      nixosConfigurations = import ./nixos { inherit inputs; };

      # Standalone home-manager configuration entrypoint
      # Available through 'home-manager --flake .#your-username@your-hostname'
      homeConfigurations = import ./home { inherit inputs; };

      formatter = self.lib.forEachSystem ({ pkgs, ... }: pkgs.nixpkgs-fmt);

      packages = self.lib.forEachSystem ({ pkgs, ... }: {
        nvim = import ./nvim { inherit pkgs; };
      });

      devShells = import ./devShells { inherit inputs; };
    };
}
