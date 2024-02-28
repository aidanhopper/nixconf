{ config, pkgs, ... }:

{
  xdg.configFile.nvim.source = ./config;
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    defaultEditor = true;
  };      
}
