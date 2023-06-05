{
  config,
  pkgs,
  ...
}: 

let 
  modules = [
    ./hypr/hypr.nix
    ./kitty/kitty.nix
    ./foot/foot.nix
  ];
in
{
  imports = modules;
}
