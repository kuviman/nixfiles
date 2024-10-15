{ inputs }:

inputs.self.lib.forEachSystem ({ pkgs, ... }: {
  default = with pkgs; mkShell {
    packages = [ lua-language-server ];
  };
})
