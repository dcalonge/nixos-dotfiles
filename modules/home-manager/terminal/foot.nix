{ config, ... }:
{
  programs.foot = {
    enable = true;
    settings.main = {
      include = "${config.xdg.configHome}/foot/colors.ini";
      font = "JetBrainsMono Nerd Font:size=10";
      shell = "${config.programs.fish.package}/bin/fish";
      pad = "8x8";
    };
  };
}
