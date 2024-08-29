{ lib, pkgs, config, ... }:

{
  imports = [
    ./xremap
    ./sunshine
    ./jellyfin
    ./ssh
    ./jetbrains
  ];
}

