{ lib, config, pkgs, ... }:

{
  options = {
    sunshine.enable = lib.mkEnableOption "enable sunshine";
  };

  config = lib.mkIf config.sunshine.enable {
    services.avahi.publish.enable = true;
    services.avahi.publish.userServices = true;
    services.sunshine.enable = true;
    services.sunshine.autoStart = true;
    services.sunshine.capSysAdmin = true;
    services.sunshine.applications.apps = [
      steam
    ];
  };
}
