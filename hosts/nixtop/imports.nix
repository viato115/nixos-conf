
{
  config,
  pkgs,
  ...
}:
let
  modules = [
    ../../modules/services/greetd/default.nix
    #    ../../modules/tui/programs/nh/nh.nix
  ];
in
{
  imports = modules;
}
