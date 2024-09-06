{ lib, pkgs, config, ... }:

{
  
  options = {
    kitty.enable = lib.mkEnableOption "enable kitty";
  };

  config = lib.mkIf config.kitty.enable {
    programs.kitty = {
      enable = true;
      settings = {
        hide_window_decorations = false;
        enable_audio_bell = false;
      };
    };
  };

}
