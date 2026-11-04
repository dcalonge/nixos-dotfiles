{ config, ... }:
{
  flake.modules.nixos.laptop-amd.home-manager.users.${config.username} = {
    programs.mpv.config.hwdec = "vulkan";

    wayland.windowManager.mango.settings.monitor_rule = "name:^eDP-1$,scale:1.2";
  };
}
