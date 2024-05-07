{ lib, pkgs, config, ... }:

{
  imports = [
    ./xremap
    ./sunshine
    ./ssh
  ];
}

