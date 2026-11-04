{
  flake.modules.homeManager.base = {
    xdg.enable = true;
    xdg.userDirs = {
      enable = true;
      createDirectories = true;
    };
  };
}
