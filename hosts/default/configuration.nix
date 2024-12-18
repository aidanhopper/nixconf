{ inputs, config, pkgs, lib, ... }:

{
  imports = [ # Include the results of the hardware scan. 
    ./hardware-configuration.nix
    inputs.home-manager.nixosModules.default
    inputs.xremap-flake.nixosModules.default
    inputs.nixvim.nixosModules.default 
    #inputs.sops-nix.nixosModules.sops
    ../../nixosModules
  ];
#sops.defaultSopsFile = ../../secrets/secrets.yaml; sops.defaultSopsFormat = "yaml"; sops.age.keyFile = "/home/aidan/.config/sops/age/keys.txt";

 #sops.secrets.tailscaleAuthKey = { };
 #sops.secrets.tailscaleAPIKey = { };
 #sops.secrets.sshKey = { };

  # Bootloader.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.useOSProber = true;

  #boot.loader.efi.canTouchEfiVariables = true;

  networking = {
    hostName = "desktop"; # Define your hostname.
    bridges.br0.interfaces = [ "ens18" ];
    useDHCP = false;
    interfaces."br0".useDHCP = true;
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

  services.xserver = {
    enable = true;
    videoDrivers = ["nvidia"];
    desktopManager.gnome.enable = true;
    displayManager = {
      gdm.enable = true;
      defaultSession = "gnome";
      autoLogin = {
        enable = true;
        user = "aidan";
      };
    };
  };

  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;

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
  };

  users.users.aidan = {
    isNormalUser = true;
    description = "aidan";
    extraGroups = [ "docker" "wheel" "input" "video" "sound" "libvirtd" "media" ];
    packages = with pkgs; [
      docker-compose
      chromium
      xclip
      sops
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
  networking.firewall.allowedTCPPorts = [ 2626 ];
  networking.firewall.allowedUDPPorts = [ 2626 ];
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
  services.sunshine = {
    enable = true;
    openFirewall = true;
    autoStart = true;
    capSysAdmin = true;
    applications = {
      env = {
          PATH = "$(PATH):$(HOME)\/.local\/bin";
      };
      apps = [
        {
          name = "Desktop";
        }
      ];
    };
    settings = {
      channels = 3;
      sunshine_name = "nixos";
    };
  };

  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      package = pkgs.qemu_kvm;
      runAsRoot = true;
      swtpm.enable = true;
      ovmf = {
        enable = true;
        packages = [(pkgs.OVMF.override {
          secureBoot = true;
          tpmSupport = true;
        }).fd];
      };
    };
  };

  services.syncthing = {
    enable = true;
    user = "aidan";
    dataDir = "/home/aidan/Documents";
    configDir = "/home/aidan/.config/syncthing";
    overrideFolders = true;
    overrideDevices = true;
    settings = {
      devices = {
        "tablet" = { id = "XAPOSJA-CBIKN7C-RE6KWMP-QCCSFY5-TLEXV6U-VNZPUHU-YDIWMEJ-QATSWQZ"; };
        "phone" = { id = "T6FN7MD-KMONNOG-RMBPOVG-EKWL56W-SQ3CYKY-3RDIRJI-B7I6RWN-66J7GQI"; };
      };
      folders = {
        "Notes" = {
          path = "/home/aidan/Notes";
          devices = [ "tablet" "phone" ];
        };
      };
    };
  };

  systemd.services.syncthing.environment.STNODEFAULTFOLDER = "true";

  jetbrains.enable = true;

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

  nvim.enable = true;
  
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
