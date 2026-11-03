{ ... }:
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
    memoryPercent = 50;
    priority = 100;
  };

  hardware.cpu.amd.updateMicrocode = true;

  hardware.amdgpu.initrd.enable = true;

  environment.sessionVariables.LIBVA_DRIVER_NAME = "radeonsi";
}
