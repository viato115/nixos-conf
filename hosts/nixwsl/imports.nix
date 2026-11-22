
{
  config,
  pkgs,
  ...
}:
let
  modules = [
    ./hardware-configuration.nix
    ../../modules/nixos/programs/nh/nh.nix
    ../../modules/nixos/services/greetd/default.nix
    ../../modules/home/services/dunst/dunst.nix
  ];
in
{
  imports = modules;
}
