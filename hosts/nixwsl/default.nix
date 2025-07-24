{ 
  config, 
  inputs,
  pkgs,
  user,
  modules,
  lib,
  ... 
}:{

# NixOS-WSL specific options are documented on the NixOS-WSL repository:
# https://github.com/nix-community/NixOS-WSL
{
  wsl.enable = true;
  wsl.defaultUser = "nixos";

  imports = [
    #  inputs.sops-nix.nixosModules.sops
    #"${(import ./nix/sources.nix).sops-nix}/modules/sops"
    ./imports.nix

    # include NixOS-WSL modules
    <nixos-wsl/modules>
  ];

  
  #sops.defaultSopsFile = ../secrets/secrets.yaml;
  #sops.defaultSopsFormat = "yaml";
  #sops.age.keyFile = "/home/user/.config/sops/age/key.txt";

  # System settings

  networking.hostName = "nixwsl";
  networking.networkmanager.enable = true;

  sound = {
    enable = true;
    mediaKeys = {
      enable = true;
      volumeStep = "5%";
    };
  };

  services.pulseaudio.enable = false;
  security.rtkit.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
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

  
  services = {
    printing = {
      enable = true;
      drivers = [ pkgs.cnijfilter2 ];
    };
  };

  services.libinput.enable = true;

  hardware.bluetooth = {
    enable = false;
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
  #  networking.firewall = {
  #    enable = true;
  #    allowedTCPPorts = [ 22 ];
  #  };

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


  # AMD should work ootb, unsure of wsl?
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };


  hardware.ipu6.enable = false;


  nix = {
    #package = pkgs.nixFlakes;
    extraOptions = ''
      experimental-features = flakes
      extra-experimental-features = nix-command
      keep-outputs = true
      keep-derivations = true
    '';
    settings = {
      auto-optimise-store = true;
    };

    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 14d";
    };
  };


  environment = {
    variables = {
      EDITOR = "vim";
      BROWSER = "firefox";
      NIXOS_CONFIG = "$HOME/.config/nixos/hosts/nixwsl/default.nix";
      NIXOS_CONFIG_DIR = "$HOME/.config/nixos/";
    };
    sessionVariables = {
      FLAKE = "$HOME/.config/nixos";
    };
  };


  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.initrd.verbose = false;
  boot.consoleLogLevel = 3;
  boot.kernelParams = [ "quiet" "udev.log_priority=3" ];
  boot.loader.timeout = 2;
  networking.dhcpcd.wait = "background";
  system.stateVersion = "22.11"; 


 # User and Package settings

  users.users.nico = {
    isNormalUser = true;
    extraGroups = [ "nico" "wheel" "networkmanager" "video" "adbusers" "libvirtd" ]; 
    # openssh.authorizedKeys.keys = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDCfggG2mdBPxyn8O9N/j0PR7fDKcZmm9HJDdmCmTTmo nico@nix"];
    packages = with pkgs; [                                 # User specific PKGS
    ];
#    shell = "${pkgs.bash}/bin/bash";
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
    acpid
    alsa-utils
    htop
    libinput
    pciutils
    tree
    rustc
    cargo
    gnumake
    file
    strace
    ltrace
    gdb
    xxd
    #sops
  ];

  environment.pathsToLink = [ "/share/bash-completion" ];

  nixpkgs.config.allowUnfree = true;


  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?
}
