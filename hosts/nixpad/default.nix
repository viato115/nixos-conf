{ 
  config, 
  pkgs,
  user,
  lib,
  ... 
}: {
  imports = [
    ./hardware-configuration.nix
    /home/nico/.config/nixos/modules/greetd/default.nix
    /home/nico/.config/nixos/modules/battery/battery_monitor.nix
    /home/nico/.config/nixos/modules/battery/suspend.nix
  ];

  # System settings

  networking.hostName = "nixpad";
  networking.networkmanager.enable = true;
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 22 ];
  };


  sound = {
    enable = true;
    mediaKeys = {
      enable = true;
      volumeStep = "5%";
    };
  };

  hardware.pulseaudio.enable = false;
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

  
  services.libinput.enable = true;
  services.printing.enable = true;
  services.logind = {
    lidSwitch = "suspend-then-hibernate";
    lidSwitchDocked = "suspend-then-hibernate";
    lidSwitchExternalPower = "suspend";
    extraConfig = ''
      HandlePowerKey = ignore
    '';
  };


## ## Battery management ##

  services.tlp = {
    enable = true;
    settings = {
      START_CHARGE_THRESH_BAT0 = 40;
      STOP_CHARGE_THRESH_BAT0 = 90;
      CPU_BOOST_ON_AC= 1;
      CPU_BOOST_ON_BAT= 0;
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
      RUNTIME_PM_ON_AC = "on";
      RUNTIME_PM_ON_BAT = "auto";
      SOUND_POWER_SAVE_ON_AC = 0;
      SOUND_POWER_SAVE_ON_BAT = 1;
    #  CPU_MAX_PERF_ON_AC = 100;
    #  CPU_MAX_PERF_ON_BAT = 70;
    };
  };

  # services.thermald.enable = true;

  services.throttled = {
    enable = true;
  };


  modules.battery_monitor.enable = true;

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
  hardware.opengl = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver
      vaapiIntel
      vaapiVdpau
      libvdpau-va-gl
    ];
  };


  hardware.ipu6.enable = false;

  hardware.sensor.iio = {
    enable = true;
  };


  nix = {
    package = pkgs.nixFlakes;
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


  environment.variables = {
    EDITOR = "nvim";
    BROWSER = "firefox";
    NIXOS_CONFIG = "$HOME/.config/nixos/hosts/nixpad/default.nix";
    NIXOS_CONFIG_DIR = "$HOME/.config/nixos/";
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
    extraGroups = [ "wheel" "networkmanager" "video" "adbusers" "libvirtd" ]; 
    packages = with pkgs; [                                 # User specific PKGS
    ];
#    shell = "${pkgs.bash}/bin/bash";
  };

  environment.systemPackages = with pkgs; [                 # System wide PKGS
    vim 
    iio-sensor-proxy
    wget
    git
    xdg-utils
    ncurses
    gcc
    killall
    nfs-utils
    zip
    unzip
    intel-gpu-tools
    gammastep
    acpid
    geoclue2
    alsa-utils
    powertop
    powerstat
    htop
    libinput
    pciutils
    tree
    rustc
    cargo
    virt-manager
    gnumake
  ];

  programs.light.enable = true;
  programs.adb.enable = true;

  environment.pathsToLink = [ "/share/bash-completion" ];

  virtualisation.libvirtd.enable = true;

  programs.dconf.enable = true;

  services.blueman.enable = true;

  services.actkbd = {
    enable = true;
    bindings = [
     # { keys = [ 113 ]; events = [ "key" ]; command = "/run/current-system/sw/bin/runuser -l nico -c 'amixer -q set Master toggle'"; }
     # { keys = [ 114 ]; events = [ "key" ]; command = "/run/current-system/sw/bin/runuser -l nico -c 'amixer -q set Master 5%- unmute'"; }
     # { keys = [ 115 ]; events = [ "key" ]; command = "/run/current-system/sw/bin/runuser -l nico -c 'amixer -q set Master 5%+ unmute'"; }
      { keys = [ 224 ]; events = [ "key" ]; command = "/run/current-system/sw/bin/runuser -l nico -c 'light -U 5'"; }
      { keys = [ 225 ]; events = [ "key" ]; command = "/run/current-system/sw/bin/runuser -l nico -c 'light -A 5'"; }
    ];
  };

  nixpkgs.config.allowUnfree = true;
}
