{ pkgs, config, ... }:
{
  programs.kitty = {
    enable = true;
    settings = {
      hide_window_decorations = true;
    };
  };
}
