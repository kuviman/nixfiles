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

  outputs = { self, nixpkgs, home-manager, systems, ... }@inputs:
    let
      pkgsFor = system: import nixpkgs { inherit system; };

      forEachSystem = f: nixpkgs.lib.genAttrs (import systems) (system:
        let pkgs = pkgsFor system;
        in f { inherit system pkgs; });
    in
    {
      # NixOS configuration entrypoint
      # Available through 'nixos-rebuild --flake .#your-hostname'
      nixosConfigurations =
        let
          mkOs = hostname:
            let system = "x86_64-linux"; in
            nixpkgs.lib.nixosSystem {
              # Pass flake inputs to our config
              specialArgs = { inherit inputs hostname system self; };
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
        };

      # Standalone home-manager configuration entrypoint
      # Available through 'home-manager --flake .#your-username@your-hostname'
      homeConfigurations =
        let
          mkHome = username: hostname:
            let system = "x86_64-linux"; in
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

      formatter = forEachSystem ({ pkgs, ... }: nixpkgs.legacyPackages.x86_64-linux.nixpkgs-fmt);

      # https://www.reddit.com/r/NixOS/comments/scf0ui/how_would_i_update_desktop_file/
      patchDesktop = pkgs: pkg: appName: from: to:
        with pkgs;
        lib.hiPrio (runCommand "$patched-desktop-entry-for-${appName}" { } ''
          ${coreutils}/bin/mkdir -p $out/share/applications
          ${gnused}/bin/sed 's#${from}#${to}#g' < ${pkg}/share/applications/${appName}.desktop > $out/share/applications/${appName}.desktop
        '');

      packages = forEachSystem ({ pkgs, ... }: {
        nvim = import ./nvim { inherit pkgs; };
      });

      devShells = forEachSystem ({ pkgs, ... }: {
        default = with pkgs; mkShell {
          packages = [ lua-language-server ];
        };
      });
    };
}
