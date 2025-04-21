{
  description = "Kuvi Man nix configs";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable"; # TODO just use stable
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    # Secrets
    sops.url = "github:Mic92/sops-nix";
    # Home manager
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    ttv.url = "github:kuviman/ttv";
    kuvibot.url = "github:kuviman/kuvibot";

    hyprpanel.url = "github:Jas-SinghFSU/HyprPanel";

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

      devShells = self.lib.forEachSystem ({ system, ... }: {
        default = self.lib.mkShell { inherit system; };
        full = self.lib.mkShell {
          inherit system;
          neovim.enable = true;
          nix.enable = true;
          utils.enable = true;
          zsh.enable = false; # not working properly
          shellHook = "export SHELL=zsh";
          # env.SHELL = "zsh";
        };
      });
    };
}
