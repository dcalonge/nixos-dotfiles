{ config, ... }:
{
  services.mako = {
    enable = true;
    settings = {
      include = "${config.xdg.configHome}/mako/colors";
      font = "JetBrainsMono Nerd Font 10";
      anchor = "top-center";
      layer = "overlay";
      border-size = 1;
      group-by = "category,app-icon";
      default-timeout = 3000;
      margin = "30,0,0,0";

      "category=\"osd-text\"" = {
        history = 0;
        format = "<b>%s</b>\\n%b";
      };

      "category=\"osd\"" = {
        font = "JetbrainsMono Nerd Font 10";
        history = 0;
        format = "<b>%s</b>\\n%b";
      };
    };
  };
}
