{
  config,
  pkgs,
  lib,
  #inputs,
  ...
}: {
  home.file.".local/bin/notifications" = {
    executable = true;
    text = ''
      #!/bin/bash
      
      [[ $(eww windows | grep '*menu') ]] && \
        eww close menu && \
        eww open notifications || \
        eww open --toggle notifications
    '';
  };
}
