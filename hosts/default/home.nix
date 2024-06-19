{ config, pkgs, lib, ... }:

{

  imports = [
    ../../homeManagerModules
  ];

  dev.enable = true;

  home.username = "aidan";
  home.homeDirectory = "/home/aidan";

  home.packages = with pkgs; [
    discord
    firefox
    steam
    spotify
    wl-clipboard
    obsidian
    xclip
    zip
    unzip
    jq
    cachix
    obs-studio
    prismlauncher
  ];

  sway.enable = true;
  home.stateVersion = "24.05";

  programs.home-manager.enable = true;

}
