{
  flake.modules.nixos.desktop = {
    security.polkit.enable = true;
  };

  flake.modules.homeManager.desktop =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      wallpaper = "${config.home.homeDirectory}/Pictures/wallpaper";
    in
    {
      home.sessionVariables = {
        GRIM_DEFAULT_DIR = "${config.home.homeDirectory}/Pictures/Screenshots/";
        ELECTRON_OZONE_PLATFORM_HINT = "auto";
        XDG_CURRENT_DESKTOP = "mango";
        XDG_SESSION_TYPE = "wayland";
        XDG_SESSION_DESKTOP = "mango";
        QT_QPA_PLATFORM = "wayland";
        QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
      };

      home.packages = with pkgs; [
        wl-clipboard
        wlr-randr
        wdisplays
        grim
        slurp
        brightnessctl
        playerctl
        libnotify
        xdg-utils
        pulsemixer
        impala
        bluetui
        qalculate-gtk
      ];

      programs.bash = {
        enable = true;
        profileExtra = ''
          if [ -z "$WAYLAND_DISPLAY" ] && [ -n "$XDG_VTNR" ] && [ "$XDG_VTNR" -eq 1 ]; then
            exec ${lib.getExe' config.wayland.windowManager.mango.package "mango"} >"$HOME/.mango.log" 2>&1
          fi
        '';
      };

      services.cliphist.enable = true;
      services.polkit-gnome.enable = true;

      services.udiskie = {
        enable = true;
        automount = true;
        notify = true;
        tray = "never";
      };

      systemd.user.services.swaybg = {
        Unit = {
          Description = "Wallpaper";
          PartOf = [ config.wayland.systemd.target ];
          After = [ config.wayland.systemd.target ];
          ConditionPathExists = wallpaper;
        };
        Service = {
          ExecStart = "${pkgs.swaybg}/bin/swaybg -i ${wallpaper}";
          Restart = "on-failure";
        };
        Install.WantedBy = [ config.wayland.systemd.target ];
      };

      # Started with SUPER+s, not with the session
      services.wlsunset = {
        enable = true;
        latitude = 40.4165;
        longitude = -3.70256;
      };
      systemd.user.services.wlsunset.Install.WantedBy = lib.mkForce [ ];
    };
}
