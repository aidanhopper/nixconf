#Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ inputs, config, pkgs, lib, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      inputs.home-manager.nixosModules.default
      inputs.xremap-flake.nixosModules.default
      inputs.sops-nix.nixosModules.sops
      ../../nixosModules
    ];

  sops.defaultSopsFile = ../../secrets/secrets.yaml;
  sops.defaultSopsFormat = "yaml";
  sops.age.keyFile = "/home/aidan/.config/sops/age/keys.txt";

  sops.secrets.tailscaleAuthKey = { };
  sops.secrets.tailscaleAPIKey = { };
  sops.secrets.vaultwardenMasterPassword = { };
  sops.secrets.sshKey = { };

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Setup keyfile
  boot.initrd.secrets = {
    "/crypto_keyfile.bin" = null;
  };

  fileSystems."/media" = {
    device = "10.0.0.119:/mnt/proxmox/media";
    fsType = "nfs";
  };

  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking = {
    hostName = "desktop"; # Define your hostname.
    bridges.br0.interfaces = [ "enp3s0" ];
    useDHCP = false;
    interfaces."br0".useDHCP = true;
    firewall = {
      enable = true;
      allowedTCPPorts = [ 
        80
        443
        8080
        5657
        25565 
        47984
        47989
        47990
        48010
      ];
      allowedUDPPorts = [
        80
        443
        25565
        47998
        47999
        48000
        48002
      ];
    };
  };

  # Set your time zone.
  time.timeZone = "America/Los_Angeles";
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.displayManager.gdm.wayland = true;
  services.xserver.desktopManager.gnome.enable = true;
  services.xserver.displayManager = {
    defaultSession = "gnome";
#    autoLogin = {
#      enable = true;
#      user = "aidan";
#    };
  };

  services.xserver.videoDrivers = ["nvidia"];

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.aidan = {
    isNormalUser = true;
    description = "aidan";
    extraGroups = [ "docker" "wheel" "input" "video" "sound" "libvirtd" "media" ];
    packages = with pkgs; [
      docker-compose
      chromium
      xclip
      qbittorrent-nox
      sops
    #  thunderbird
    ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  nix.settings.experimental-features = [ "nix-command" "flakes" ];


  # List services that you want to enable:

  users.groups.media = {
    gid = 1800;
    members = [
      "aidan" 
    ];
  };

  users.defaultUserShell = pkgs.zsh;
  environment.shells = with pkgs; [ zsh ];
  programs.zsh.enable = true;
  security.polkit.enable = true;
  xremap.gnome.enable = true;

  services.tailscale = {
    enable = true;
    useRoutingFeatures = "client"; # need this for mullvad to work
    #authKeyFile = config.sops.secrets.tailscaleAuthKey.path;
  };

  services.sunshine.package = pkgs.sunshine.override {cudaSupport = true;};

  ssh.enable = true;

  services.avahi.publish.enable = true;
  services.avahi.publish.userServices = true;
  services.sunshine.enable = true;
  services.sunshine.autoStart = true;
  services.sunshine.capSysAdmin = true;
  services.sunshine.applications = {
    env = {
        PATH = "$(PATH):$(HOME)\/.local\/bin";
    };
    apps = [
      {
        name = "Desktop";
      }
    ];
  };

 #  services.caddy = {
 #    enable = true;
 #    virtualHosts."media.aidahop.xyz".extraConfig = ''
 #      reverse_proxy http://localhost:8096
 #    '';
 #    virtualHosts."request.aidahop.xyz".extraConfig = ''
 #      reverse_proxy http://localhost:5055
 #    '';
 #    virtualHosts."mc.aidahop.xyz".extraConfig = ''
 #      reverse_proxy http://localhost:25565
 #    '';
 #  };

 #  containers.jellyfin = {
 #    autoStart = true;
 #    privateNetwork = true;
 #    hostBridge = "br0";
 #    enableTun = true;
 #    bindMounts = {
 #      "/media" = {
 #        hostPath = "/media";
 #        isReadOnly = true;
 #      };
 #      "${config.sops.secrets.tailscaleAuthKey.path}".isReadOnly = true;
 #    };
 #    config = { config, pkgs, lib, ... }: {
 #      system.stateVersion = "unstable";
 #      services.jellyfin.enable = true;
 #      services.tailscale = {
 #        enable = true;
 #        useRoutingFeatures = "client";
 #        authKeyFile = /run/secrets/tailscaleAuthKey;
 #      };
 #      networking = {
 #        hostName = "jellyfin";
 #        useDHCP = lib.mkForce true;
 #        useHostResolvConf = lib.mkForce false;
 #        firewall = {
 #          enable = true;
 #          allowedTCPPorts = [ 8096 ];
 #        };
 #      };
 #    };
 #  };

 #  services.lidarr = {
 #    enable = true;
 #    group = "media";
 #  };

 #  services.sonarr = {
 #    enable = true;
 #    group = "media";
 #  };

 #  services.radarr = {
 #    enable = true;
 #    group = "media";
 #  };

 #  services.readarr = {
 #    enable = true;
 #    group = "media";
 #  };

 #  services.prowlarr.enable = true;
 #  services.jellyseerr.enable = true;

 #  containers.qbittorrent = {
 #    autoStart = true;
 #    privateNetwork = true;
 #    hostBridge = "br0";
 #    enableTun = true;
 #    bindMounts = {
 #      "/Downloads" = {
 #        hostPath = "/Downloads";
 #        isReadOnly = false;
 #      };
 #      "${config.sops.secrets.tailscaleAuthKey.path}".isReadOnly = true;
 #    };
 #    config = { config, pkgs, lib, ... }: {
 #      services.tailscale = {
 #        enable = true;
 #        useRoutingFeatures = "client"; # need this for mullvad to work
 #        authKeyFile = /run/secrets/tailscaleAuthKey;
 #      };
 #      systemd.services.qbittorrent = {
 #        enable = true;
 #        after = [ "network.target" ];
 #        wantedBy = [ "multi-user.target" ];
 #        serviceConfig = {
 #          ExecStart = "${pkgs.qbittorrent-nox}/bin/qbittorrent-nox";
 #          ExecStop = "pkill qbittorrent-nox";
 #          Restart = "on-failure";
 #        };
 #      };
 #      networking = {
 #        hostName = "qbittorrent"; # Define your hostname.
 #        useDHCP = lib.mkForce true;
 #        useHostResolvConf = lib.mkForce false;
 #        firewall = {
 #          enable = true;
 #          allowedTCPPorts = [ 8080 ];
 #        };
 #      };
 #    };
 #  };

  virtualisation.docker.enable = true;

# virtualisation.oci-containers = {
#   backend = "docker";
#   containers.pterodactyl = {
#     image = "ghcr.io/pterodactyl/panel:latest";
#     ports = [
#       "127.0.0.1:8180:80"
#     ];
#     volumes = [
#       "/var/lib/pterodactyl/var/:/app/var/"
#       "/var/lib/pterodactyl/nginx/:/etc/nginx/http.d/"
#       "/var/lib/pterodactyl/certs/:/etc/letsencrypt/"
#       "/var/lib/pterodactyl/logs/:/app/storage/logs"
#     ];
#     extraOptions = [
#       "--add-host=host.docker.internal:host-gateway"
#       "--log-opt=tag='gitea'"
#     ];
#   };
# };

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };
  
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = true;
    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.beta;
  };
  
  hardware.keyboard.qmk.enable = true;
  
  home-manager = {
    extraSpecialArgs = { inherit inputs; };
    users = {
      "aidan" = import ./home.nix;
    };
    useGlobalPkgs = true;
  };

  services.udev.packages = [ pkgs.dolphinEmu ];

  systemd.services.NetworkManager-wait-online.enable = lib.mkForce false;

  nix.settings.trusted-users = ["root" "aidan"];

  system.stateVersion = "unstable";

}
