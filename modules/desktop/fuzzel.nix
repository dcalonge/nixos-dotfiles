{
  flake.modules.homeManager.desktop =
    { config, ... }:
    {
      programs.fuzzel = {
        enable = true;
        settings = {
          main = {
            include = "${config.xdg.configHome}/fuzzel/colors.ini";
            dpi-aware = "no";
            width = 40;
            lines = 15;
            minimal-lines = 1;
            icons-enabled = "no";
            hide-prompt = "no";
            font = "JetbrainsMono Nerd Font:size=12:antialias=true:hinting=true";
            prompt = ''"> "'';
            terminal = "${config.programs.foot.package}/bin/foot";
            layer = "overlay";
            line-height = 32;
          };
          border = {
            width = 2;
            radius = 0;
          };
          key-bindings = {
            next = "none";
            prev = "none";
            next-with-wrap = "Down Control+n";
            prev-with-wrap = "Up Control+p";
          };
        };
      };
    };
}
