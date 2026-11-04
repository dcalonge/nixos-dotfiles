{ config, inputs, ... }:
let
  inherit (config) username;
  homeModules = config.flake.modules.homeManager;
in
{
  # Each NixOS aggregate brings its Home Manager counterpart for the user.
  flake.modules.nixos.base = {
    imports = [ inputs.home-manager.nixosModules.home-manager ];

    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      backupFileExtension = "hm-backup";
      users.${username}.imports = [ homeModules.base ];
    };
  };

  flake.modules.nixos.desktop = {
    home-manager.users.${username}.imports = [ homeModules.desktop ];
  };
}
