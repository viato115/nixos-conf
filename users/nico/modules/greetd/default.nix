{ pkgs, config, lib, ... }:
{
  services.greetd = {
    enable = true;
    # restart = false;
    settings = {
      default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd /home/nico/.local/bin/wrappedhl";
        user = "greeter";
      };
     # initial_session = {
     #   command = "${Hyprland}";
     #   user = "nico";
     # };
    };
  };
}
