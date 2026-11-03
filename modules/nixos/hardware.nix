{ pkgs, ... }:
{
  hardware.enableRedistributableFirmware = true;
  hardware.bluetooth.enable = true;

  hardware.graphics = {
    enable = true;
    extraPackages = [ pkgs.libvdpau-va-gl ];
  };

  environment.sessionVariables = {
    VDPAU_DRIVER = "va_gl";
    NIXOS_OZONE_WL = "1";
  };

  services.acpid.enable = true;
  services.upower.enable = true;
  services.tuned.enable = true;
  services.udisks2.enable = true;
}
