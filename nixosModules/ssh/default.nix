{ lib, config, pkgs, ... }:

{
  options = {
    ssh.enable = lib.mkEnableOption "enable ssh & sshd";
  };

  config = lib.mkIf config.ssh.enable {
    services.openssh = {
      enable = true;
      settings = {
        PasswordAuthentication = false;
        PermitRootLogin = "no";
      };
    };
    services.fail2ban = {
      enable = true; 
      maxretry = 5;
      ignoreIP = [
        "192.168.254.0/24"
      ];
      bantime = "24h";
      bantime-increment = {
        enable = true; # Enable increment of bantime after each violation
        formula = "ban.Time * math.exp(float(ban.Count+1)*banFactor)/math.exp(1*banFactor)";
        multipliers = "1 2 4 8 16 32 64";
        maxtime = "168h"; # Do not ban for more than 1 week
        overalljails = true; # Calculate the bantime based on all the violations
      };
    };

    users.users."aidan".openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIElBiCeuhYeemvHxL3CTr5dqNX+rFVFRH0YWp3t4r4je aidanhop1@gmail.com"
    ];
  };
}
