{ pkgs, config, lib, ... }:
{
  imports = [
    ./nix.nix
    ./neovim.nix
    ./utils.nix
    ./zsh.nix
  ];
  options = {
    packages = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      description = "list of dependencies";
      default = [ ];
    };
    env = lib.mkOption {
      type = lib.types.submoduleWith {
        modules = [
          (env: {
            config._module.freeformType = lib.types.lazyAttrsOf lib.types.anything;
          })
        ];
      };
      description = "Environment variables";
      default = { };
    };
    shellHook = lib.mkOption {
      type = lib.types.lines;
    };
  };
  config = {
    shellHook =
      let
        libPath = pkgs.lib.makeLibraryPath config.packages;
      in
      ''
        export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:${libPath}"
      '';
  };
}
