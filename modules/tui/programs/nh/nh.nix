{ config, pkgs, lib, ... }:
{
  programs.nh = {
    enable = true;
    flake = "/home/nico/.config/nixos";
  };
}
