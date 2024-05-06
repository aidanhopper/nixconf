{ lib, config, pkgs, ... }:

{
  options = {
    sunshine.enable = lib.mkEnableOption "enable sunshine";
  };

  config = lib.mkIf config.sunshine.enable {
    
    services.sunshine.enable = true;

    security.wrappers.sunshine = {
      owner = "root";
      group = "root";
      capabilities = "cap_sys_admin+p";
      source = "${pkgs.sunshine}/bin/sunshine";
    };

    systemd.services.sunshine = {
      startLimitBurst = 5;
      startLimitIntervalSec = 500;
      serviceConfig = {
        ExecStart = "${config.security.wrapperDir}/sunshine";
        Restart = "on-failure";
        RestartSec = "5s";
      };
    };

  };
}
