
{
  config,
  pkgs,
  ...
}:
let
  modules = [
    ../../modules/services/greetd/default.nix
    #    ../../modules/tui/programs/nh/nh.nix
    ../../modules/gaming/gaming.nix
  ];
in
{
  imports = modules;
}
