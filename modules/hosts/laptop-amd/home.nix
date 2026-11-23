{ config, ... }:
{
  flake.modules.nixos.laptop-amd.home-manager.users.${config.username} =
    { lib, pkgs, ... }:
    let
      wlr-randr = lib.getExe' pkgs.wlr-randr "wlr-randr";
    in
    {
      programs.mpv.config.hwdec = "vulkan";

      wayland.windowManager.mango.settings = {
        monitor_rule = "name:^eDP-1$,scale:1.2";

        switchbind = [
          "lid_on,spawn,${wlr-randr} --output eDP-1 --off"
          "lid_off,spawn,${wlr-randr} --output eDP-1 --on"
        ];
      };
    };
}
