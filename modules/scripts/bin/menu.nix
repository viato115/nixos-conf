{
  config,
  pkgs,
  lib,
  #inputs,
  ...
}: {
  home.file.".local/bin/menu" = {
    executable = true;
    text = ''
      #!/bin/bash
      
      [[ $(eww windows | grep '*notifications') ]] && \
        eww close notifications && \
        eww open menu || \
        eww open --toggle menu
    '';
  };
}
