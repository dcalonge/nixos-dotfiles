{ config, inputs, ... }:
let
  inherit (config.flake.modules) nixos;
in
{
  flake.nixosConfigurations.laptop-amd = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      nixos.base
      nixos.desktop
      nixos.laptop-amd
    ];
  };

  flake.modules.nixos.laptop-amd = {
    imports = [ ./_hardware-configuration.nix ];

    networking.hostName = "laptop-amd";

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
  };
}
