{ pkgs, config, lib, ... }:

{
  options = {
    tmux.enable = lib.mkEnableOption "enable tmux";
  };

  config = lib.mkIf config.tmux.enable {
    programs.tmux.enable = true;
    home.file.".config/tmux" = {
      source = ./config;
      recursive = true;
    };
  };

}
