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
    ../../profiles/nixos/core.nix
    ../../profiles/nixos/desktop.nix
  ];

  
  #sops.defaultSopsFile = ../secrets/secrets.yaml;
  #sops.defaultSopsFormat = "yaml";
  #sops.age.keyFile = "/home/user/.config/sops/age/key.txt";

  # System settings

  networking.hostName = "nixtop";

  services.flatpak.enable = false;

  # Optional nixtop PipeWire low-latency settings:
  # services.pipewire.lowLatency = {
  #   enable = true;
  #   quantum = 64;
  #   rate = 48000;
  # };



  
 # services = {
 #   printing = {
 #     enable = true;
 #     drivers = [ pkgs.cnijfilter2 ];
 #   };
 # };

  # Start Niri by default; other registered sessions remain selectable.
  programs.niri.enable = true;

  #services.greetd.settings.default_session.command = lib.mkForce (
  #  "${pkgs.tuigreet}/bin/tuigreet --time "
  #  + "--sessions ${config.services.displayManager.sessionData.desktops}/share/wayland-sessions "
  #  + "--cmd ${config.programs.niri.package}/bin/niri-session"
  #);

  hardware.bluetooth = {
    enable = lib.mkDefault true;
  };

  services.blueman.enable = lib.mkDefault true;


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


  #services.journald.extraConfig = ''           # remove cause obsolete
  #  SystemMaxUse=50M
  #  SystemMaxFileSize=10M
  #  RuntimeMaxUse=50M
  #  RuntimeMaxFileSize=10M
  #'';


  xdg.portal = {
    enable = true;
    extraPortals = [
    pkgs.xdg-desktop-portal-gtk
    ];
    config.common.default = "*";
  };


  # Intel/OpenGL
  hardware.graphics = lib.mkDefault {
    enable = true;
    enable32Bit = true;
  };


  hardware.ipu6.enable = false;


  nix = {
    settings = {
      substituters = [
        "https://cache.nixos.org"
        "https://hyprland.cachix.org"
      ];
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      ];
      #trusted-substituters = ["https://hyprland.cachix.org"];
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
  

  #boot.initrd.verbose = false;               # remove cause obsolete
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
#    openssh.authorizedKeys.keys = [" "];
    packages = with pkgs; [                                 # User specific PKGS
      ###### specified in user/home.nix
    ];
  };

  environment.systemPackages = with pkgs; [                 # System wide PKGS
    vim 
    wget
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
    freetype
    spotify
    android-tools
    xwayland-satellite
  ];


  programs = {
    #light.enable = true;
    dconf.enable = true;
    #adb.enable = false;
  };

  environment.pathsToLink = [ "/share/bash-completion" ];

  nixpkgs.config.allowUnfree = true;
}
