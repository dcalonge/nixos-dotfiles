{ config, ... }:
{
  programs.zathura = {
    enable = true;
    extraConfig = "include ${config.xdg.configHome}/zathura/matugen-colors";
  };

  programs.mpv.enable = true;

  programs.imv.enable = true;
}
