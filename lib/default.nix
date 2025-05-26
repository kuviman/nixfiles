{ inputs }:
rec {
  pkgsFor = system: import inputs.nixpkgs-stable { inherit system; };
  forEachSystem = f: inputs.nixpkgs-stable.lib.genAttrs (import inputs.systems) (system:
    let pkgs = pkgsFor system;
    in f { inherit system pkgs; });

  # https://www.reddit.com/r/NixOS/comments/scf0ui/how_would_i_update_desktop_file/
  patchDesktop = pkgs: pkg: appName: from: to:
    with pkgs;
    lib.hiPrio (runCommand "$patched-desktop-entry-for-${appName}" { } ''
      ${coreutils}/bin/mkdir -p $out/share/applications
      ${gnused}/bin/sed 's#${from}#${to}#g' < ${pkg}/share/applications/${appName}.desktop > $out/share/applications/${appName}.desktop
    '');
  mkShell = import ../mkShell { inherit inputs; };
}
