{ pkgs, ... }:
{
  environment.variables.FLAKE = "$HOME/.config/nixos#nixpad";
  programs.nh = {
    enable = true;
    flake = "/home/nico/.config/nixos#nixpad";
    
    clean = {
      enable = false;
      extraArgs = "--keep-since 7d --keep 3";
    };
  };
}
