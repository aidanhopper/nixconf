{ lib, pkgs, config, ... }:

{
  imports = [
    ./nvim
    ./zsh
    ./kitty
    ./tmux
    ./sway
    ./direnv
    ./git
    ./nixconf
  ];

  options = {
    dev.enable = lib.mkEnableOption "enable development environment";
  };

  config = lib.mkIf config.dev.enable {
    ./sway
    nvim.enable = true;
    kitty.enable = true;
    tmux.enable = true;
    zsh.enable = true;
    direnv.enable = true;
    git.enable = true;
    nixconf.enable = true;
  };

}
