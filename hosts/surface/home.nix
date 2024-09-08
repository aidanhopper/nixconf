{ config, pkgs, ... }:

{

  imports = [
    ../../homeManagerModules
  ];

  dev.enable = true;

  home.username = "aidan";
  home.homeDirectory = "/home/aidan";

  home.packages = with pkgs; [
    firefox
    moonlight-qt
    jetbrains-toolbox
    zathura
  ];

  home.stateVersion = "24.05";

  programs.home-manager.enable = true;


}
