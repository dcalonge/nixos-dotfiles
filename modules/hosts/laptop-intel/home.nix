{ config, ... }:
{
  flake.modules.nixos.laptop-intel.home-manager.users.${config.username} = {
    # VA-API rather than Vulkan video on this older GPU
    programs.mpv.config.hwdec = "vaapi";
  };
}
