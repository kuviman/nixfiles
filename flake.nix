{
  description = "Kuvi Man nix configs";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    kdenlive-pin-nixpkgs.url = "nixpkgs/cfec6d9203a461d9d698d8a60ef003cac6d0da94";

    # Secrets
    sops.url = "github:Mic92/sops-nix";
    nur.url = "github:nix-community/NUR";
    # Home manager
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    hyprland.url = "github:hyprwm/Hyprland";

    ttv.url = "github:kuviman/ttv";

    # TODO: take a look at this:
    # Shameless plug: looking for a way to nixify your themes and make
    # everything match nicely? Try nix-colors!
    # nix-colors.url = "github:misterio77/nix-colors";
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs:
    let
      system = "x86_64-linux";
    in
    {
      # NixOS configuration entrypoint
      # Available through 'nixos-rebuild --flake .#your-hostname'
      nixosConfigurations =
        let
          mkOs = hostname:
            nixpkgs.lib.nixosSystem {
              # Pass flake inputs to our config
              specialArgs = { inherit inputs hostname system; };
              # > Our main nixos configuration file <
              modules = [ ./nixos/configuration.nix ];
            };
        in
        {
          mainix = mkOs "mainix";
          swiftix = mkOs "swiftix";
        };

      # Standalone home-manager configuration entrypoint
      # Available through 'home-manager --flake .#your-username@your-hostname'
      homeConfigurations =
        let
          mkHome = username: hostname:
            home-manager.lib.homeManagerConfiguration
              {
                pkgs = nixpkgs.legacyPackages.${system}; # Home-manager requires 'pkgs' instance
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
        };

      formatter.${system} = nixpkgs.legacyPackages.x86_64-linux.nixpkgs-fmt;

      # https://www.reddit.com/r/NixOS/comments/scf0ui/how_would_i_update_desktop_file/
      patchDesktop = pkgs: pkg: appName: from: to:
        with pkgs;
        lib.hiPrio (runCommand "$patched-desktop-entry-for-${appName}" { } ''
          ${coreutils}/bin/mkdir -p $out/share/applications
          ${gnused}/bin/sed 's#${from}#${to}#g' < ${pkg}/share/applications/${appName}.desktop > $out/share/applications/${appName}.desktop
        '');
    };
}
