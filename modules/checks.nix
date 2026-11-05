{ config, lib, ... }:
let
  hosts = config.flake.nixosConfigurations;
in
{
  # `nix flake check` builds each host in full: the whole NixOS system
  # (`system.build.toplevel`), including its Home Manager generation, scripts,
  # Mango's config check and Nixvim. A failing system therefore fails CI instead
  # of only showing up on the laptop.
  perSystem =
    { system, ... }:
    {
      checks = lib.mapAttrs' (
        name: host: lib.nameValuePair "host-${name}" host.config.system.build.toplevel
      ) (lib.filterAttrs (_: host: host.pkgs.stdenv.hostPlatform.system == system) hosts);
    };
}
