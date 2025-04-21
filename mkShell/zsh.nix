{ lib, config, pkgs, ... }:

let
  zshrc = pkgs.writeText ".zshrc" ''
    export ZSH="$ZDOTDIR/oh-my-zsh"
    zstyle ':omz:update' mode never
    ZSH_THEME="bureau"
    plugins=(git)
    source "$ZSH/oh-my-zsh.sh"
    source "${pkgs.zsh-syntax-highlighting}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
  '';
  zsh = pkgs.stdenv.mkDerivation {
    name = "zsh-with-oh-my-zsh";

    src = pkgs.fetchFromGitHub {
      owner = "ohmyzsh";
      repo = "ohmyzsh";
      rev = "de1ca65dcaebd19f5ca6626616bb79b529362458";
      sha256 = "sha256-ag/hVeCvrGHYSchdeTQKOtqFvmtn12vJZJM+EIpyYpE=";
    };
    nativeBuildInputs = [ pkgs.makeWrapper pkgs.zsh ];
    buildPhase = "true"; # Nothing to build
    installPhase = ''
      mkdir -p $out/zsh
      cp -r . $out/zsh/oh-my-zsh
      cp ${zshrc} $out/zsh/.zshrc
    '';

    dontPatchShebangs = true;

    fixupPhase = ''
      makeWrapper ${pkgs.zsh}/bin/zsh $out/bin/zsh \
        --set ZDOTDIR $out/zsh
    '';
  };
in
{
  options.zsh = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
    };
  };
  config = lib.mkIf config.zsh.enable {
    packages = [ zsh ];
    env = {
      SHELL = "zsh";
    };
  };
}
