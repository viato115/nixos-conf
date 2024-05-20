{
  config,
  pkgs,
  lib,
  #inputs,
  ...
}: {
  home.file.".local/bin/volume" = {
    executable = true;
    text = ''
      #!/bin/bash
      
      [[ -z $(pgrep checkvolume) ]] && checkvolume &
      
      # requieres pamixer
      
      case $1 in
      --up)
        # Unmute
        pamixer -u >/dev/null
        # +2%
        pamixer -i 2 >/dev/null
        ;;
      --down)
        # Unmute
        pamixer -u >/dev/null
        # -2%
        pamixer -d 2 >/dev/null
        ;;
      --toggle)
        # Toggle mute
        pamixer -t >/dev/null
           ;;
      esac
    '';
  };
}
