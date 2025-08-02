{ 
  config, 
  inputs,
  pkgs,
  user,
  modules,
  lib,
  ... 
}:{

  imports = [
    #  inputs.sops-nix.nixosModules.sops
    #"${(import ./nix/sources.nix).sops-nix}/modules/sops"
    ./hardware-configuration.nix
    ./imports.nix
  ];

  
  #sops.defaultSopsFile = ../secrets/secrets.yaml;
  #sops.defaultSopsFormat = "yaml";
  #sops.age.keyFile = "/home/user/.config/sops/age/key.txt";

  # System settings

  networking.hostName = "nixtop";
  networking.networkmanager.enable = true;


  services.pulseaudio.enable = false;
  security.rtkit.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;

   # lowLatency = {
   #   enable = true;
   #   quantum = 64;
   #   rate = 48000;
   # };
  };


  time = {
    timeZone = "Europe/Berlin";
    hardwareClockInLocalTime = true;
  };
  

  i18n = let
    defaultLocale = "en_US.UTF-8";
    de = "de_DE.UTF-8";
  in {
    inherit defaultLocale;
    extraLocaleSettings = {
      LANG = defaultLocale;
      LC_COLLATE = defaultLocale;
      LC_CTYPE = defaultLocale;
      LC_MESSAGE = defaultLocale;

      LC_ADDRESS = de;
      LC_IDENTIFICATION = de;
      LC_MEASUREMENT = de;
      LC_MONETARY = de;
      LC_NAME = de;
      LC_NUMERIC = de;
      LC_PAPER = de;
      LC_TELEPHONE = de;
      LC_TIME = de;
    };

    supportedLocales = lib.mkDefault [
      "en_US.UTF-8/UTF-8"
      "de_DE.UTF-8/UTF-8"
    ];
  };

  console = {
    font = "${pkgs.terminus_font}/share/consolefonts/ter-128n.psf.gz";
    packages = with pkgs;[ terminus_font ]; 
    keyMap = "de-latin1";
  };

  
 # services = {
 #   printing = {
 #     enable = true;
 #     drivers = [ pkgs.cnijfilter2 ];
 #   };
 # };

  services.libinput.enable = true;

  hardware.bluetooth = {
    enable = true;
  };



  ### Enable SSH support

  #  programs.gnupg.agent = {
  #    enable = true;
  #    enableSSHSupport = true;
  #  };
  #
  #  services.openssh = {
  #    enable = true;
  #    hostKeys = [];
  #    settings = {
  #      PermitRootLogin = "no";
  #      PasswordAuthentication = false;
  #    };
  #    openFirewall = true;
  #  };
  # 
    networking.firewall = {
      enable = true;
  #    allowedTCPPorts = [ 22 ];
    };


  services.journald.extraConfig = ''
    SystemMaxUse=50M
    SystemMaxFileSize=10M
    RuntimeMaxUse=50M
    RuntimeMaxFileSize=10M
  '';


  xdg.portal = {
    enable = true;
    extraPortals = [
    pkgs.xdg-desktop-portal-gtk
    pkgs.xdg-desktop-portal-hyprland
    ];
    config.common.default = "*";
  };


  # Intel/OpenGL
  hardware.graphics = {
    enable = true;
  };



  hardware.ipu6.enable = false;


  nix = {
    settings = {
      substituters = ["https://hyprland.cachix.org"];
      trusted-substituters = ["https://hyprland.cachix.org"];
      trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
      auto-optimise-store = true;
    };

    extraOptions = ''
      experimental-features = flakes
      extra-experimental-features = nix-command
      keep-outputs = true
      keep-derivations = true
    '';

    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 14d";
    };
  };


  environment = {
    variables = {
      EDITOR = "nvim";
      BROWSER = "firefox";
      NIXOS_CONFIG = "$HOME/.config/nixos/hosts/nixtop/default.nix";
      NIXOS_CONFIG_DIR = "$HOME/.config/nixos/";
    };
    sessionVariables = {
      FLAKE = "$HOME/.config/nixos";
    };
  };


  boot.loader.systemd-boot.enable = false;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub = {
    enable = true;
    devices = [ "nodev" ];
    efiSupport = true;
    useOSProber = true;
  };
  boot.initrd.verbose = false;
  boot.consoleLogLevel = 3;
  boot.kernelParams = [ "quiet" "udev.log_priority=3" ];
  boot.loader.timeout = 2;
  networking.dhcpcd.wait = "background";
  system.stateVersion = "22.11"; 

# Automount my windows drive 
  fileSystems."/mnt/windows" = {
    fsType = "ntfs3";
    device = "/dev/disk/by-uuid/BE64A34F64A3096B";
    options = [ "defaults" "windows_names" "umask=022" "uid=1000" ];
  };
  
 # User and Package settings

  users.users.nico = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "video" "adbusers" "libvirtd" ]; 
#    openssh.authorizedKeys.keys = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDCfggG2mdBPxyn8O9N/j0PR7fDKcZmm9HJDdmCmTTmo nico@nix"];
    packages = with pkgs; [                                 # User specific PKGS
    ];
  };

  environment.systemPackages = with pkgs; [                 # System wide PKGS
    vim 
    wget
    git
    xdg-utils
    ncurses
    gcc
    killall
    nfs-utils
    zip
    unzip
    gammastep
    acpid
    geoclue2
    alsa-utils
    htop
    libinput
    pciutils
    tree
    rustc
    cargo
   # virt-manager
   # gnumake
   bluez
   # file
   # strace
   # ltrace
   # gdb
   # xxd
   #sops
   ntfs3g
   jdk
  ];


  programs = {
    light.enable = true;
    dconf.enable = true;
    adb.enable = false;
  };

  environment.pathsToLink = [ "/share/bash-completion" ];

  nixpkgs.config.allowUnfree = true;
}
