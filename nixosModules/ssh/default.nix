{ lib, config, pkgs, ... }:

{
  options = {
    ssh.enable = lib.mkEnableOption "enable ssh & sshd";
  };

  config = lib.mkIf config.ssh.enable {
    services.openssh.enable = true;
    users.users."aidan".openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIElBiCeuhYeemvHxL3CTr5dqNX+rFVFRH0YWp3t4r4je aidanhop1@gmail.com"
    ];
  };
}
