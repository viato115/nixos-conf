{ config, pkgs, lib, ... }: 
{
  ### thanks to reddit:Xziden03 (https://www.reddit.com/r/NixOS/comments/1hdsfz0/what_do_i_have_to_do_to_make_my_xbox_controller/)
  hardware.bluetooth = {
    enable = lib.mkDefault true;
#    powerOnBoot = true;
#    settings.General = {
#      experimental = true;
#      Privacy = "device";
#      JustWorksRepairing = "always";
#      Class = "0x000100";
#      FastConnectable = true;
#    };
    };
  
  services.blueman.enable = lib.mkDefault true;

  hardware.xpadneo.enable = false;    # enables the driver for Xbox One wireless controller

  boot = {
    extraModulePackages = with config.boot.kernelPackages; [ ];
    extraModprobeConfig = ''
      options bluetooth disable_ertm=1>
    '';
  };
}
