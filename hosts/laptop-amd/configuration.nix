{ ... }:
{
  imports = [ ./hardware-configuration.nix ];

  hardware.cpu.amd.updateMicrocode = true;

  hardware.amdgpu.initrd.enable = true;

  environment.sessionVariables.LIBVA_DRIVER_NAME = "radeonsi";
}
