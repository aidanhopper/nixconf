{ lib, pkgs, config, ... }:

{
  imports = [
    ./nvim
    ./zsh
    ./kitty
    ./tmux
    ./sway
  ];
}
