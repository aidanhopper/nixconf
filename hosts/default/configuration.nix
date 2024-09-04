{ inputs, config, pkgs, lib, ... }:

{
  imports =
    [ # Include the results of the hardware scan. 
      ./hardware-configuration.nix
      inputs.home-manager.nixosModules.default
      inputs.xremap-flake.nixosModules.default inputs.nixvim.nixosModules.default 
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


  # Enable networking
  networking = {
    hostName = "desktop"; # Define your hostname.
    bridges.br0.interfaces = [ "enp6s18" ];
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
      lightdm.greeter.enable = true;
      defaultSession = "gnome";
      autoLogin = {
        enable = true;
        user = "aidan";
      };
    };
  };


  services.xrdp.enable = true;
  services.xrdp.defaultWindowManager = "gnome-remote-desktop";
  services.xrdp.openFirewall = true;

  services.gnome.gnome-remote-desktop.enable = true;

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
      sops
      gnome-remote-desktop
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
  services.sunshine.enable = true;
  services.sunshine.openFirewall = true;
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
  
  home-manager = {
    extraSpecialArgs = { inherit inputs; };
    users = {
      "aidan" = import ./home.nix;
    };
    useGlobalPkgs = true;
  };

  programs.nixvim = {

    enable = true;
    viAlias = true;
    vimAlias = true;
    colorscheme = "murphy";
    globals.mapleader = " ";

    opts = {
      number = true;
      swapfile = false;
      cursorline = true;
      cursorcolumn = true;
      clipboard = "unnamedplus";
      relativenumber = true;
      shiftwidth = 2;
      colorcolumn = "80";
      scrolloff = 8;
      #wildmenu = true;
      #wildmode = "longest:list,full";
      #mapleader = " ";
    };

    plugins = {
      tmux-navigator.enable = true;
      telescope.enable = true;
    };

    keymaps = [

      {
	action = "<cmd>Telescope find_files<CR>";
	key = "<leader>pf";
	options = {
	  silent = true;
	};
      }

      {
	action = "<cmd>w<CR>";
	key = "<leader>w";
      }

    ];

  };

  services.udev.packages = [ pkgs.dolphinEmu ];

  systemd.services.NetworkManager-wait-online.enable = lib.mkForce false;

  nix.settings.trusted-users = ["root" "aidan"];

  system.stateVersion = "unstable";

}
