
{
  config,
  pkgs,
  ...
}:
let
  modules = [
    ./hardware-configuration.nix
    ../../modules/tui/programs/nh/nh.nix
    ../../modules/services/greetd/default.nix
    ../../modules/services/dunst/dunst.nix
  ];
in
{
  imports = modules;
}
