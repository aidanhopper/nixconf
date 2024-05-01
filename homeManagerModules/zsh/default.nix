{ lib, config, pkgs, ... }:

{

  options = {
    zsh.enable = lib.mkEnableOption "enable nvim";
  };

  config = lib.mkIf config.zsh.enable {

    programs.zsh = {
      enable = true;
      syntaxHighlighting.enable = true;
      history.size = 10000;
      history.path = "${config.xdg.dataHome}/zsh/history";
      oh-my-zsh = {
        enable = true;
        theme = "robbyrussell";
      };
      shellAliases = {
        sudo = "sudo ";
      };
    };

  };



}

