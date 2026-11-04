{
  flake.modules.homeManager.base = {
    programs.yazi = {
      enable = true;
      enableFishIntegration = true;
    };

    programs.btop = {
      enable = true;
      settings = {
        color_theme = "matugen";
        rounded_corners = false;
        shown_boxes = "cpu mem net proc gpu0";
        update_ms = 1000;
        proc_sorting = "cpu direct";
        shown_gpus = "nvidia amd intel";
        save_config_on_exit = false;
      };
    };
  };
}
