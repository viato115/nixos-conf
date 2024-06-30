{ 
  inputs,
  options,
  config,
  lib,
  pkgs,
  ...
}: {
  programs.firefox = {
    enable = true;


    profiles.nicolas = {
      bookmarks = {};

      extensions = with inputs.firefox-addons.packages.${pkgs.system}; [ 
        ublock-origin 
        localcdn
        privacy-badger
      ];

      userChrome = builtins.readFile ./userChrome.css;
      userContent = builtins.readFile ./userContent.css;

      settings = {
        "browser.startup.homepage" = "https://viato115.github.io/personalbento/";
        "browser.search.defaultenginename" = "Google";
        "browser.search.order.1" = "Google";
      };

      search = {
        force = true;
        default = "Google";
        engines = {
          "Nix Packages" = {
            urls = [{ template = "https://search.nixos.org/packages";
              params = [
                { name = "type"; value = "packages"; }
                { name = "query"; value = "{searchTerms}"; }
              ];
            }];
            icon = "''${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
            definedAliases = [ "@np" ];
          };
          "Nix Options" = {
            urls = [{ template = "https://search.nixos.org/options";
              params = [
                { name = "type"; value = "options"; }
                { name = "query"; value = "{searchTerms}"; }
              ];
            }];
            icon = "''${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
            definedAliases = [ "@no" ];
          };
          "NixOS Wiki" = {
            urls = [{ template = "https://nixos.wiki/index.php?search={searchTerms}"; }];
            iconUpdateURL = "https://nixos.wiki/favicon.png";
            updateInterval = 24 * 60 * 1000;
            definedAliases = [ "@nw" ];
          };
          "Arch Wiki" = {
            urls = [{ template = "https://wiki.archlinux.org/index.php?search={searchTerms}"; }];
            definedAliases = [ "@aw" ];
          };
          "Home-Manager Options" = {
            urls = [{ template = "https://home-manager-options.extranix.com/?query={searchTerms}&release=master"; }];
            definedAliases = [ "@hmo" ];
            icon = "''${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
          };
          "Google".metaData.alias = "@g";
        };
      };
    };
  };
}
