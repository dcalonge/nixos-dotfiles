{ inputs, ... }:
{
  flake.modules.homeManager.desktop = {
    imports = [ inputs.wlr-monitor.homeModules.default ];

    programs.wlr-monitor = {
      enable = true;
      mango.enable = true;
      package = inputs.wlr-monitor.packages.${pkgs.stdenv.hostPlatform.system}.default;
    };
  };
}
