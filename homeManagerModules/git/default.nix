{ pkgs, config, lib, ... }:

{
  options = {
    git.enable = lib.mkEnableOption "enable git";
  };

  config = lib.mkIf config.git.enable {
    programs.git = {
      enable = true;
      userName = "Aidan Hopper";
      userEmail = "aidanhop1@gmail.com";
    };
  };
}

