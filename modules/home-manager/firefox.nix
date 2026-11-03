{
  inputs,
  pkgs,
  ...
}:
{
  programs.firefox = {
    enable = true;

    nativeMessagingHosts = [ pkgs.pywalfox-native ];

    policies.ExtensionSettings =
      let
        amo = short: "https://addons.mozilla.org/firefox/downloads/latest/${short}/latest.xpi";
      in
      {
        "uBlock0@raymondhill.net" = {
          install_url = amo "ublock-origin";
          installation_mode = "force_installed";
          toolbar_pinned = false;
        };
        "{446900e4-71c2-419f-a6a7-df9c091e268b}" = {
          install_url = amo "bitwarden-password-manager";
          installation_mode = "force_installed";
          toolbar_pinned = false;
        };
        "pywalfox@frewacom.org" = {
          install_url = amo "pywalfox";
          installation_mode = "force_installed";
          toolbar_pinned = false;
        };
        "sponsorBlocker@ajay.app" = {
          install_url = amo "sponsorblock";
          installation_mode = "force_installed";
          toolbar_pinned = false;
        };
      };

    profiles.daniel = {
      id = 0;
      isDefault = true;
      extraConfig = builtins.readFile "${inputs.betterfox}/user.js";

      settings = {
        "browser.startup.page" = 3;
        "browser.sessionstore.resume_from_crash" = true;
        "sidebar.revamp" = true;
        "sidebar.verticalTabs" = true;
        "browser.uidensity" = 1;
        "browser.toolbars.bookmarks.visibility" = "never";
        "browser.tabs.drawInTitlebar" = true;
        "widget.gtk.native-context-menus" = true;
      };

      search = {
        force = true;
        default = "ddg";
        privateDefault = "ddg";
      };
    };
  };
}
