{ lib, config, pkgs, ... }:
let
  init-dev-flake = pkgs.writeShellScriptBin "init-dev-flake" ''
    selected=$(echo '
c-cpp
c#
cue
empty
go 
java
latex
nim
nix
node
ocaml
python
rush
shell
haskell
zig
    ' | ${pkgs.gawk}/bin/awk 'NF' | ${pkgs.fzf}/bin/fzf)
    echo $selected
    ${pkgs.nix}/bin/nix flake init --template "github:the-nix-way/dev-templates#$selected"
    ${pkgs.direnv}/bin/direnv allow
  '';
in
{
  options = {
    direnv.enable = lib.mkEnableOption "enable direnv";
  };

  config = lib.mkIf config.direnv.enable {

    programs.direnv = {
      enable = true;
      enableZshIntegration = true;
      nix-direnv.enable = true;
    };

    home.packages = with pkgs; [
      init-dev-flake
    ];

  };
}
