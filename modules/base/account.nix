{ config, ... }:
let
  inherit (config) username;
in
{
  flake.modules.nixos.base =
    { pkgs, ... }:
    {
      users.users.${username} = {
        isNormalUser = true;
        description = "Daniel Calonge";
        shell = pkgs.bashInteractive;
        extraGroups = [
          "wheel"
          "video"
          "input"
        ];
      };

      security.doas = {
        enable = true;
        wheelNeedsPassword = true;
        extraRules = [
          {
            groups = [ "wheel" ];
            persist = true;
          }
        ];
      };
      security.sudo.enable = false;
    };
}
