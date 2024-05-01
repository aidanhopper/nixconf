{ pkgs, config, lib, ... }:

{
  options = {
    sway.enable = lib.mkEnableOption "enable sway";
  };

  config = lib.mkIf config.sway.enable {

    wayland.windowManager.sway = {
      enable = true;
      config = rec {
        modifier = "Mod4";
        terminal = "kitty";
      };
    };
    
    home.file.".config/sway" = {
      source = ./config;
      recursive = true;
    };

  };

}
