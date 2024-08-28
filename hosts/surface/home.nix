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
    steam
    spotify
    moonlight-qt
    virt-manager
  ];

  home.stateVersion = "24.05";

  programs.home-manager.enable = true;


}
