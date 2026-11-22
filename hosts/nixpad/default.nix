{ 
  pkgs,
  lib,
  config,
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

  networking.hostName = "nixpad";

  services = {
    printing = {
      enable = true;
      drivers = [ pkgs.cnijfilter2 ];
    };
  };

  services.logind.settings.Login = {
      HandleLidSwitch = "suspend-then-hibernate";
      HandleLidSwitchDocked = "suspend-then-hibernate";
      HandleLidSwitchExternalPower = "suspend";
  };

  systemd.sleep.settings.Sleep = {
    HibernateDelaySec = "2h";
    HibernateOnACPower = true;
  };

  hardware.bluetooth = {
    enable = true;
  };


  systemd.services.configure-sound-leds = rec {   # thanks to AndrewKvalheim @ Codeberg for this hack
    enable = true;
    wantedBy = [ "sound.target" ];
    after = wantedBy;
    serviceConfig.Type = "oneshot";
    script = ''
      echo follow-route > /sys/class/sound/ctl-led/mic/mode
    '';
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

## ## Battery management ##

  services.tlp = {
    enable = true;
    settings = {
  #    START_CHARGE_THRESH_BAT0 = 40;
      STOP_CHARGE_THRESH_BAT0 = 90;
      CPU_BOOST_ON_AC= 1;
      CPU_BOOST_ON_BAT= 0;
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
      RUNTIME_PM_ON_AC = "on";
      RUNTIME_PM_ON_BAT = "auto";
      SOUND_POWER_SAVE_ON_AC = 0;
      SOUND_POWER_SAVE_ON_BAT = 1;
    };
  };

  # services.thermald.enable = true;

  services.throttled = {
    enable = true;
  };

  services.upower.enable = true;

  powerManagement.powertop.enable = true;

  modules.battery_monitor.enable = true;


  xdg.portal = {
    enable = true;
    extraPortals = [
    pkgs.xdg-desktop-portal-gtk
    ];
    config.common.default = "*";
  };


  # Intel/OpenGL
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver
      #vaapiIntel
      #vaapiVdpau     # remove cause obsolete
      libva-vdpau-driver
      libvdpau-va-gl
    ];
  };


  hardware.ipu6.enable = false;


  ## Enable screen rotation on my Thinkpad
  hardware.sensor.iio = {
    enable = true;
  };

  services.iio-niri = {
    enable = true;
    extraArgs = [
      "--monitor"
      "eDP-1"
      "--lock-rotation"
    ];
  };


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
    };


  };


  environment = {
    variables = {
      EDITOR = "nvim";
      BROWSER = "firefox";
      NIXOS_CONFIG = "$HOME/.config/nixos/hosts/nixpad/default.nix";
      NIXOS_CONFIG_DIR = "$HOME/.config/nixos/";
    };
    sessionVariables = {
      FLAKE = "$HOME/.config/nixos";
    };
  };




  # Window Manager / DE setup
  
  programs.niri.enable = true;



  ### this shows all registered sessions in tuigreet
  services.greetd.settings.default_session.command = lib.mkForce (
    "${pkgs.tuigreet}/bin/tuigreet --time "
    + "--sessions ${config.services.displayManager.sessionData.desktops}/share/wayland-sessions "
    + "--cmd ${config.programs.niri.package}/bin/niri-session"
  );



  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  #boot.initrd.verbose = false;       # remove cause obsolete
  boot.consoleLogLevel = 3;
  boot.kernelParams = [ "quiet" "udev.log_priority=3" ];
  boot.loader.timeout = 2;
  networking.dhcpcd.wait = "background";
  system.stateVersion = "22.11"; 


 # User and Package settings

  users.users.nico = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "video" "adbusers" "libvirtd" ]; 
    openssh.authorizedKeys.keys = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDCfggG2mdBPxyn8O9N/j0PR7fDKcZmm9HJDdmCmTTmo nico@nix"];
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
    bluez
    file
    strace
    ltrace
    gdb
    xxd
    #sops
    android-tools
    xwayland-satellite
  ];

  programs = {
    #light.enable = true;
    dconf.enable = true;
    #adb.enable = false;
  };

  environment.pathsToLink = [ "/share/bash-completion" ];

  virtualisation.libvirtd.enable = true;

  services = {
    blueman.enable = true;

    actkbd = {
      enable = true;
      bindings = [
       # { keys = [ 113 ]; events = [ "key" ]; command = "/run/current-system/sw/bin/runuser -l nico -c 'amixer -q set Master toggle'"; }
       # { keys = [ 114 ]; events = [ "key" ]; command = "/run/current-system/sw/bin/runuser -l nico -c 'amixer -q set Master 5%- unmute'"; }
       # { keys = [ 115 ]; events = [ "key" ]; command = "/run/current-system/sw/bin/runuser -l nico -c 'amixer -q set Master 5%+ unmute'"; }
       #{ keys = [ 224 ]; events = [ "key" ]; command = "/run/current-system/sw/bin/runuser -l nico -c 'light -U 5'"; }
       #{ keys = [ 225 ]; events = [ "key" ]; command = "/run/current-system/sw/bin/runuser -l nico -c 'light -A 5'"; }
      ];
    };
  };

  nixpkgs.config.allowUnfree = true;
}
