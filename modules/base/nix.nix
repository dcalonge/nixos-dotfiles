{ config, ... }:
let
  inherit (config) flakeDir;
in
{
  flake.modules.nixos.base = {
    nix.settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      auto-optimise-store = true;
      trusted-users = [ "@wheel" ];
    };

    programs.nh = {
      enable = true;
      flake = flakeDir;
      clean = {
        enable = true;
        dates = "weekly";
        extraArgs = "--keep-since 14d --keep 5";
      };
    };

    # Flakes need git to read this repo
    programs.git.enable = true;
  };
}
