{ pkgs, ... }:
{
  imports = [ ./hardware-configuration.nix ];

  swapDevices = [
    {
      device = "/var/lib/swapfile";
      size = 8 * 1024;
      priority = 10;
    }
  ];

  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 100;
    priority = 100;
  };

  hardware.cpu.intel.updateMicrocode = true;

  hardware.graphics.extraPackages = [ pkgs.intel-media-driver ];

  environment.sessionVariables.LIBVA_DRIVER_NAME = "iHD";

  services.thermald.enable = true;

  hardware.intel-gpu-tools.enable = true;
}
