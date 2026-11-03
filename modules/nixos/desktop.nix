{
  config,
  lib,
  vars,
  ...
}:
{
  # programs.xwayland stays off: its package has to be compiled locally
  programs.mango.enable = true;
  services.graphical-desktop.enable = true;

  # Same routing as the Arch mango-portals.conf; the portals come from programs.mango
  xdg.portal.config.mango = lib.mkForce {
    default = [
      "gtk"
      "wlr"
    ];
    "org.freedesktop.impl.portal.FileChooser" = [ "gtk" ];
    "org.freedesktop.impl.portal.ScreenCast" = [ "wlr" ];
    "org.freedesktop.impl.portal.Access" = [ "gtk" ];
    "org.freedesktop.impl.portal.Notification" = [ "gtk" ];
    "org.freedesktop.impl.portal.Secret" = [ "gnome-keyring" ];
  };

  programs.gtklock = {
    enable = true;
    config.main.style = "${config.users.users.${vars.user}.home}/.config/gtklock/style.css";
  };

  programs.fish.enable = true;
  programs.dconf.enable = true;
  programs.git.enable = true;
  security.polkit.enable = true;
}
