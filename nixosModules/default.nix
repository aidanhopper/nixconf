{ lib, pkgs, config, ... }:

{
  imports = [
    ./xremap
    ./sunshine
    ./nvim
    ./ssh
    ./jetbrains
  ];
}

