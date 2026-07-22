{ pkgs, config, lib, ... }:
{
  services.greetd = {
    enable = true;

    settings = {
      default_session = {
        command = "${pkgs.tuigreet}/bin/tuigreet --time --cmd /home/nico/.local/bin/wrappedhl";
        user = "greeter";
      };
    };
  };
}
