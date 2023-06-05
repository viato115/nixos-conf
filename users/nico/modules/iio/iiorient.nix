{ pkgs, lib, config, ... }:
# generalises this as a HM module:
# monitor-sensor | awk '$4 ~ /normal/ { print "0" }; $4 ~ /left-up/ { print "1" }; $4 ~ /right-up/ { print "3" }; $4 ~ /bottom-up/ { print "2" }; { system("") }' | xargs -rI{} hyprctl keyword monitor 'eDP-1,transform,{}'

with lib;
let
	inherit (lib) mkOption;

	handlers = {
		hyprctl = {
			normal = "0";
			left-up = "1";
			bottom-up = "2";
			right-up = "3";
		};
	};

	cfg = config.services.iiorient;

	iiorientScript = handler: hpkg: devices: monitors:
		let
			otrans = getAttr handler handlers;
			handlerCmdTpl = ''hyprctl --batch "''
				+ builtins.concatStringsSep " ; " (map (d: "keyword device:${d}:transform {}") devices)
				+ " ; "
				+ builtins.concatStringsSep " ; " (map (m: "keyword monitor ${m},transform,{}") monitors)
				+ ''"'';
			name = "iiorient.sh";
		in
		pkgs.writeShellApplication {
			inherit name;
			runtimeInputs = with pkgs; [
				gawk
				iio-sensor-proxy
			] ++ [ hpkg ];
			text =
				''
				monitor-sensor \
					| awk ' ''
					+ (with builtins; concatStringsSep "; " (lists.zipListsWith (a: b: ''$4 ~ /${a}/ { print "${b}" }'') (attrNames otrans) (map (a: getAttr a otrans) (attrNames otrans))))
					+ ''; { system("") };' \
					| xargs -rI{} ${handlerCmdTpl}
				'';

		} + "/bin/${name}";

in
{
  options.services.iiorient = {
    enable = mkEnableOption "iiorient";

    handler = mkOption {
      type = types.enum [ "hyprctl" ];
      default = "hyprctl";
      defaultText = literalExpression "hyprctl";
      description =
	  	''Command used to process output of `monitor-sensor` (after translation if given).
		Currently only `hyprctl` is supported and will be handled like this:
		```
		hyprctl --batch "keyword monitor <monitors[i]>,transform,<orientation> ; keyword device:<devices[i]>:transform <orientation> ; ... "
		```
		where `<orientation>` is the orientation corresponding to the mapping `{ "normal": "0", ... , "right-up": "3" }`.
		'';
    };

	handlerPackage = mkOption {
		type = types.package;
		default = config.wayland.windowManager.hyprland.package;
		defaultText = literalExpression "config.wayland.windowManager.hyprland.package";
		description =
			''
			The package containing the program that will handle the output of `monitor-sensor`.
			(Currently must be `hyprland`, or at least a package containing a compatible `hyprctl`)
			'';
	};

	devices = mkOption {
		type = with types; listOf str;
		default = [ "elan2514:00-04f3:29f5" ];
		defaultText = literalExpression ''[ "elan2514:00-04f3:29f5" ]'';
		description =
			''Device name to substitute placeholder `<device[i]>` in the `handler`.
			'';
	};

	monitors = mkOption {
		type = with types; listOf str;
		default = [ "eDP-1" ];
		defaultText = literalExpression ''[ "eDP-1" ]'';
		description =
			''Monitor name to substitute placeholder `<monitor[i]>` in the `handler`.
			'';
	};

  };

  config = mkIf cfg.enable {
    systemd.user.services.iiorient =
	let

	in
	{
      Unit = {
        Description =
			"iiorient service: execute action based on iio-sensor-proxy's monitor-sensor output.";
        After = [ "graphical-session.target" ];
      };
      Install = { WantedBy = [ "graphical-session.target" ]; };
      Service = {
        ExecStart = iiorientScript cfg.handler cfg.handlerPackage cfg.devices cfg.monitors;
      };
    };
  };

}
