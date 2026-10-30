{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfgHome = config.xdg.configHome;
  templates = ./matugen/templates;
  defaults = ./matugen/defaults;

  matugenTargets = {
    waybar = {
      input = "waybar-colors.css";
      output = "${cfgHome}/waybar/colors.css";
      hook = "pkill -SIGUSR2 waybar || true";
      default = "waybar-colors.css";
    };
    fuzzel = {
      input = "fuzzel-colors.ini";
      output = "${cfgHome}/fuzzel/colors.ini";
      default = "fuzzel-colors.ini";
    };
    foot = {
      input = "foot-colors.ini";
      output = "${cfgHome}/foot/colors.ini";
      hook = "pkill -USR1 foot || true";
      default = "foot-colors.ini";
    };
    gtk3 = {
      input = "gtk3.css";
      output = "${cfgHome}/gtk-3.0/matugen-colors.css";
      hook = "pkill -f xdg-desktop-portal-gtk";
      default = "gtk3.css";
    };
    gtk4 = {
      input = "gtk4.css";
      output = "${cfgHome}/gtk-4.0/matugen-colors.css";
      default = "gtk4.css";
    };
    mako = {
      input = "mako.conf";
      output = "${cfgHome}/mako/colors";
      hook = "makoctl reload || true";
      default = "mako-colors";
    };
    nvim = {
      input = "nvim.yaml";
      output = "${cfgHome}/nvim/lua/config/matugen-theme.yaml";
      hook = "pkill -USR1 nvim || true";
      default = "nvim.yaml";
    };
    btop = {
      input = "btop.theme";
      output = "${cfgHome}/btop/themes/matugen.theme";
      default = "btop.theme";
    };
    yazi = {
      input = "yazi.toml";
      output = "${cfgHome}/yazi/theme.toml";
      default = "yazi.toml";
    };
    zathura = {
      input = "zathurarc";
      output = "${cfgHome}/zathura/matugen-colors";
      default = "zathura-colors";
    };
    gtklock = {
      input = "gtklock.css";
      output = "${cfgHome}/gtklock/style.css";
      default = "gtklock.css";
    };
    mango = {
      input = "mango.conf";
      output = "${cfgHome}/mango/colors.conf";
      hook = "mmsg dispatch reload_config";
      default = "mango-colors.conf";
    };
  };

  matugenConfig = (pkgs.formats.toml { }).generate "matugen-config.toml" {
    config = { };
    templates = lib.mapAttrs (
      _: t:
      {
        input_path = "${templates}/${t.input}";
        output_path = t.output;
      }
      // lib.optionalAttrs (t ? hook) { post_hook = t.hook; }
    ) matugenTargets;
  };
in
{
  home.packages = [ pkgs.matugen ];

  xdg.configFile."matugen/config.toml".source = matugenConfig;

  # matugen rewrites these files at runtime, so they are not managed by Home
  # Manager; seed them once so every include exists on a fresh install.
  home.activation.seedMatugenColors = lib.hm.dag.entryAfter [ "linkGeneration" ] (
    lib.concatStrings (
      lib.mapAttrsToList (_: t: ''
        if [ ! -e ${lib.escapeShellArg t.output} ]; then
          run install -Dm644 ${defaults}/${t.default} ${lib.escapeShellArg t.output}
        fi
      '') matugenTargets
    )
  );

  gtk = {
    enable = true;
    theme = {
      name = "adw-gtk3-dark";
      package = pkgs.adw-gtk3;
    };
    iconTheme = {
      name = "Adwaita";
      package = pkgs.adwaita-icon-theme;
    };
    cursorTheme = {
      name = "Adwaita";
      package = pkgs.adwaita-icon-theme;
      size = 24;
    };
    font = {
      name = "JetBrainsMono Nerd Font";
      size = 11;
    };
    colorScheme = "dark";

    gtk3 = {
      extraConfig = {
        gtk-toolbar-style = "GTK_TOOLBAR_ICONS";
        gtk-toolbar-icon-size = "GTK_ICON_SIZE_LARGE_TOOLBAR";
        gtk-button-images = 0;
        gtk-menu-images = 0;
        gtk-sound-theme-name = "freedesktop";
        gtk-enable-event-sounds = 1;
        gtk-enable-input-feedback-sounds = 0;
        gtk-error-bell = 1;
        gtk-xft-antialias = 1;
        gtk-xft-hinting = 1;
        gtk-xft-hintstyle = "hintslight";
        gtk-xft-rgba = "rgb";
      };
      extraCss = ''
        @import url("file://${cfgHome}/gtk-3.0/matugen-colors.css");

        /* No (default) title bar on wayland */
        headerbar.default-decoration {
          /* You may need to tweak these values depending on your GTK theme */
          margin-bottom: 50px;
          margin-top: -100px;
        }

        /* rm -rf window shadows */
        window.csd,             /* gtk4? */
        window.csd decoration { /* gtk3 */
          box-shadow: none;
        }
      '';
      bookmarks = [
        "file://${config.home.homeDirectory}/Pictures Pictures"
        "file://${config.home.homeDirectory}/mis_repos mis_repos"
        "file://${config.home.homeDirectory}/Downloads Downloads"
        "file:///media media"
      ];
    };

    gtk4 = {
      theme = null;
      extraConfig = {
        gtk-sound-theme-name = "freedesktop";
        gtk-error-bell = 1;
      };
      extraCss = ''
        @import url("file://${cfgHome}/gtk-4.0/matugen-colors.css");
      '';
    };
  };

  dconf.settings."org/gnome/desktop/interface".color-scheme = "prefer-dark";

  home.pointerCursor = {
    enable = true;
    name = "Adwaita";
    package = pkgs.adwaita-icon-theme;
    size = 24;
    gtk.enable = true;
  };

  qt = {
    enable = true;
    platformTheme.name = "gtk3";
  };
}
