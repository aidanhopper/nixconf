{ pkgs, config, lib, ... }:

let

  nixconf = pkgs.writeShellScriptBin "tmux-sessionizer" ''
    ${pkgs.git}/bin/git add /nixconf
    ${pkgs.git}/bin/git commit -m $(${coreutils/bin/date} "+%s")
    ${pkgs.git}/bin/git push
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

  }
}

