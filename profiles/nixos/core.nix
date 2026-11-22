{ ... }:
{
  # Nix settings shared by the currently configured machines.
  nix = {
    settings.auto-optimise-store = true;
    extraOptions = ''
      experimental-features = flakes
      extra-experimental-features = nix-command
      keep-outputs = true
      keep-derivations = true
    '';
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 14d";
    };
  };
}
