{
  config,
  pkgs,
  lib,
  #inputs,
  ...
}: {
  home.file.".local/bin/checkvolume" = {
    executable = true;
    text = ''
      #!/bin/bash
      
      value="$(eww get volume-percent)"
      sleep_duration=3
      
      # open eww volume
      [[ -z $(eww windows | grep -i '*' | grep volume) ]] && eww open volume
      
      while true; do
        new_value=$(eww get volume-percent)
      
        if [ "$value" != "$new_value" ]; then
          # if volume has changed, then reset sleep
          sleep_duration=3
          value="$new_value"
        else
          # if volume hasnt changed, then sleep till volume changes again
          sleep $sleep_duration
      
          # check if the volume still hasn't changed
          newest_value=$(eww get volume-percent)
          if [ "$value" == "$newest_value" ]; then
            # if not changed within the sleep time, then close eww volume
            [[ -n $(eww windows | grep -i '*' | grep volume) ]] && eww close volume ; exit
      
            # reset sleep
            sleep_duration=3
          fi
        fi
      done
    '';
  };
}
