{ pkgs, config, lib, ... }:

let

  nixconf = pkgs.writeShellScriptBin "nixconf" ''
    curdir=$(pwd)
    cd /nixconf
    ${pkgs.git}/bin/git pull
    ${pkgs.git}/bin/git add .
    ${pkgs.git}/bin/git commit -m $(date "+%s")
    ${pkgs.git}/bin/git push
    sudo nixos-rebuild $1 --flake /nixconf#$2
    cd $curdir
  '';

in
{

  options = {
    nixconf.enable = lib.mkEnableOption "enable nixconf helpers";
  };

  config = lib.mkIf config.tmux.enable {
    home.packages = [
      nixconf
    ];

  };
}

