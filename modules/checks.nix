{ config, lib, ... }:
let
  hosts = config.flake.nixosConfigurations;
in
{
  # `nix flake check` builds each host in full: the whole NixOS system
  # (`system.build.toplevel`), including its Home Manager generation, scripts,
  # Mango's config check and Nixvim. The `check` workflow evaluates these
  # without building (`--no-build`); the `update` workflow builds them before
  # committing a new lock.
  perSystem =
    { system, ... }:
    {
      checks = lib.mapAttrs' (
        name: host: lib.nameValuePair "host-${name}" host.config.system.build.toplevel
      ) (lib.filterAttrs (_: host: host.pkgs.stdenv.hostPlatform.system == system) hosts);
    };
}
