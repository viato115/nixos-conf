{ config, pkgs, ... }:
{
  environment.systemPackages = [ pkgs.g810-led];
  
  systemd.services.g610-backlight = {
    description = "Set Logitech G610 default backlight behaviour";
    after = [ "multi-user.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.g810-led}/bin/g610-led -a 25";
    };
  };
}
