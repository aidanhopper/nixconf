{ config, pkgs, ... }:

{

  imports = [
    ../../homeManagerModules
  ];

  nvim.enable = true;
  zsh.enable = true;
  kitty.enable = true;
  tmux.enable = true;
  sway.enable = true;

  home.username = "aidan";
  home.homeDirectory = "/home/aidan";

  home.packages = with pkgs; [
    git
    firefox
  ];

  home.stateVersion = "24.05";

  programs.home-manager.enable = true;

}
