{ pkgs, config, lib, ... }:

let

  nixconf = pkgs.writeShellScriptBin "nixconf" ''
    ${pkgs.git}/bin/git add /nixconf
    ${pkgs.git}/bin/git commit -m $(date "+%s")
    ${pkgs.git}/bin/git push
    nixos-rebuild $1 --flake /nixconf#$2
  '';

in
{

  options = {
    nixconf.enable = lib.mkEnableOption "enable nixconf helpers";
  };

  config = lib.mkIf config.tmux.enable {
    home.packages = with pkgs; [
      nixconf
    ];

  };
}

