{ pkgs, config, lib, ... }:
{
  services.greetd = {
    enable = true;
    restart = false;
    settings = {
      default_session = {
        command = "${lib.makeBinPath [pkgs.greetd.tuigreet] }/tuigreet --time --cmd ${Hyprland}";
        user = "greeter";
      };
      initial_session = {
        command = "${Hyprland}";
        user = "nico";
      };
    };
  };
}
