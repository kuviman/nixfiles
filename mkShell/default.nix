{ inputs }:

let
  lib = inputs.self.lib;

  mkEnv = config@{ system, ... }:
    let
      pkgs = lib.pkgsFor system;
      configExtraModules = config.modules or [ ];
      configModule = {
        config = builtins.removeAttrs config [ "system" "modules" ];
      };
    in
    (pkgs.lib.evalModules {
      modules = [
        ./module.nix
        configModule
      ] ++ configExtraModules;
      specialArgs = { inherit pkgs; };
    }).config;
  mkShell = config@{ system, ... }:
    let
      pkgs = lib.pkgsFor system;
      env = mkEnv config;
    in
    pkgs.mkShell
      ({
        packages = env.packages;
        shellHook = env.shellHook;
      } // env.env);
in
mkShell

# inputs.self.lib.forEachSystem ({ pkgs, ... }: {
#   default = with pkgs; mkShell {
#     packages = [ lua-language-server ];
#   };
# })
