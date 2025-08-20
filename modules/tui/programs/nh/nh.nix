{ config, lib, ... }:
{
  programs.nh = {
    enable = true;
    flake = "${config.users.users.nico.home}/.config/nixos";
    #flake = "/home/nico/.config/nixos"
    
    clean = {
      enable = false;
      extraArgs = "--keep-since 7d --keep 3";
    };
  };
}
