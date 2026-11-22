{
  pkgs,
  inputs,
  ... 
}:
{
  _module.args = { inherit inputs; };
  
  imports = [
  ./imports.nix
  ];


  # Core command-line tools shared by Nico's home configurations.
  home.packages = with pkgs; [
    fd
    nvd
    nix-output-monitor
    fastfetch
    eza
    ripgrep
    fzf
    trash-cli
    bat
    zip
    unar
    gawk
    python3
    nil
    nixpkgs-fmt
    dysk
    cmake
    openssl
    ltrace
    strace
  ];

  home.username = "nico";
  home.homeDirectory = "/home/nico";

  nixpkgs.config.allowUnfree = true;
  programs.home-manager.enable = true;  # Let Home Manager install and manage itself.
  home.stateVersion = "22.11";          # Please read the comment before changing.
}
