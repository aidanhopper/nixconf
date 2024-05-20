{ lib, config, pkgs, ... }:

{

  options = {
    nvim.enable = lib.mkEnableOption "enable nvim";
  };

  config = lib.mkIf config.nvim.enable {

    # basic config
    programs.neovim = {
      enable = true;
      viAlias = true;
      vimAlias = true;
      defaultEditor = true;
    };

    # lua config
    home.file.".config/nvim" = {
      source = ./config;
      recursive = true;
    };

    # dependencies
    home.packages = with pkgs; [
      ripgrep
      gcc
      nodejs
    ];

  };


}
