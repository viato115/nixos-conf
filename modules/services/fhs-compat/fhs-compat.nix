{ config, pkgs, lib, ... }: {
  
### Special thanks to github:Mic92 for this

  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      stdenv.cc.cc
      zlib
      fuse3
      openssl
      curl
      dbus
      attr
      bzip2
      libnotify
      libusb1
      libuuid
      util-linux
      zstd
    ]
    ++ lib.optionals (config.harware.graphics.enable) [
      pipewire
      cups
      mesa
      libpulseaudio
      alsa-lib
      cairo
      glib
      gtk3
      libGL
      vulkan-loader
    ];
  };
}
