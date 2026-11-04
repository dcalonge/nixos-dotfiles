{ config, ... }:
let
  inherit (config) username;
in
{
  flake.modules.nixos.desktop =
    { config, ... }:
    {
      programs.gtklock = {
        enable = true;
        config.main.style = "${config.users.users.${username}.home}/.config/gtklock/style.css";
      };
    };

  flake.modules.homeManager.desktop =
    { pkgs, ... }:
    {
      services.swayidle = {
        enable = true;
        events.before-sleep = "${pkgs.gtklock}/bin/gtklock -d";
      };
    };
}
