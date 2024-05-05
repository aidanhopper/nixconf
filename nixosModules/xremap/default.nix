{ lib, config, pkgs, ... }:

{
  options = {
    xremap.gnome.enable = lib.mkEnableOption "enable xremap with gnome";
  };

  config = lib.mkIf config.xremap.gnome.enable {
    services.xremap = {
      withGnome = true;
      userName = "aidan";
      yamlConfig = ''
        keymap:
          - remap:
              CapsLock: Esc
      '';
    };
  };
}
