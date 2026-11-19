{
  flake.modules.nixos.desktop =
    {
      hardware.enableRedistributableFirmware = true;
      hardware.bluetooth.enable = true;

      hardware.graphics.enable = true;

      environment.sessionVariables.NIXOS_OZONE_WL = "1";

      services.acpid.enable = true;
      services.upower.enable = true;
      services.tuned.enable = true;
      services.udisks2.enable = true;
    };
}
