{ lib, config, pkgs, ... }:

{
  options = {
    jellyfin.enable = lib.mkEnableOption "enable jellyfin";
  };

  config = lib.mkIf config.jellyfin.enable {
    services.jellyfin.enable = true;
    environment.systemPackages = with pkgs; [
      jellyfin
      jellyfin-web
      jellyfin-ffmpeg
    ];
  };
}
