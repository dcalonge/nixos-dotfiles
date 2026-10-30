{
  lib,
  pkgs,
  vars,
  ...
}:
{
  imports = [ ./hardware-configuration.nix ];

  hardware.cpu.intel.updateMicrocode = true;

  hardware.graphics.extraPackages = [ pkgs.intel-media-driver ];

  environment.sessionVariables.LIBVA_DRIVER_NAME = "iHD";

  services.thermald.enable = true;

  hardware.intel-gpu-tools.enable = true;

  # VA-API rather than Vulkan video on this older GPU
  home-manager.users.${vars.user}.programs.mpv.config.hwdec = lib.mkForce "vaapi";
}
