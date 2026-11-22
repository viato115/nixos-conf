{ ... }:
{
  # Command-line configuration shared by Nico's home profiles.
  imports = [
    ../../modules/home/shells/bash/bash.nix
    ../../modules/home/programs/cli/ranger/ranger.nix
    ../../modules/home/programs/cli/btop/btop.nix
    ../../modules/home/programs/cli/nvim/nvim.nix
    ../../modules/home/programs/cli/tealdeer/tealdeer.nix
    ../../modules/home/programs/git/git.nix
  ];
}
