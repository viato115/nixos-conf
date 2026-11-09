{ pkgs, ... }:
{
  xdg.configFile."niri/config.kdl".source =
    pkgs.runCommand "niri-config.kdl" { nativeBuildInputs = [ pkgs.niri ]; } ''
      niri validate --config ${./config.kdl}
      cp ${./config.kdl} "$out"
    '';
}
