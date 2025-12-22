{
  description = "Kuvi Man nix configs";

  inputs = {
    # Nixpkgs
    nixpkgs-25-05.url = "github:nixos/nixpkgs/nixos-25.05";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    # Secrets
    sops.url = "github:Mic92/sops-nix";
    # Home manager
    home-manager.url = "github:nix-community/home-manager/release-25.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs-stable";

    niri = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    dgop = {
      url = "github:AvengeMedia/dgop";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    dankMaterialShell = {
      url = "github:AvengeMedia/DankMaterialShell";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
      inputs.dgop.follows = "dgop";
    };

    fresh = {
      url = "github:sinelaw/fresh";
    };

    ttv.url = "github:kuviman/ttv";
    kuvibot.url = "github:kuviman/kuvibot";

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

      packages = self.lib.forEachSystem ({ pkgs, pkgs-unstable, ... }: {
        nvim = import ./nvim { inherit pkgs pkgs-unstable; };
      });

      devShells = self.lib.forEachSystem ({ system, ... }: {
        default = self.lib.mkShell { inherit system; };
        nixfiles = self.lib.mkShell {
          inherit system;
          nix.enable = true;
          lua.enable = true;
        };
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
