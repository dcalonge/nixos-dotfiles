{ config, inputs, ... }:
let
  inherit (config.flake.modules) nixos;
in
{
  flake.nixosConfigurations.laptop-intel = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      nixos.base
      nixos.desktop
      nixos.laptop-intel
    ];
  };

  flake.modules.nixos.laptop-intel =
    { pkgs, ... }:
    {
      imports = [ ./_hardware-configuration.nix ];

      networking.hostName = "laptop-intel";

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
    };
}
