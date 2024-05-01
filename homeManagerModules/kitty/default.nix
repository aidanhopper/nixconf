{ lib, pkgs, config, ... }:

{
  
  options = {
    kitty.enable = lib.mkEnableOption "enable kitty";
  };

  config = lib.mkIf config.kitty.enable {
    programs.kitty = {
      enable = true;
      settings = {
        enable_audio_bell = false;
      };
    };
  };

}
