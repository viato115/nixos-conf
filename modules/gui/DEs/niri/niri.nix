{ pkgs, ... }:
{
  xdg.configFile."niri/config.kdl".source =
    pkgs.runCommand "niri-config.kdl" { nativeBuildInputs = [ pkgs.niri ]; } ''
      cat ${./config.kdl} > "$out"
      printf '\ninclude "%s"\n' "${./smoke.kdl}" >> "$out"
      niri validate --config "$out"
    '';
}
