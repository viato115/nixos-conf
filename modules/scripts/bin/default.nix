{ config, pkgs, ... }:
{
  imports = [
  ./checkvolume.nix
#  ./fetch.nix
  ./menu.nix
  ./notifications.nix
  ./volume.nix
  ];
}
