{ config, lib, ... }:
let
  inherit (config) username;
  hosts = config.flake.nixosConfigurations;
in
{
  # `nix flake check` evaluates every host and builds these: each host's Home
  # Manager generation, i.e. the parts built locally from this config (Mango's
  # config check, scripts, Nixvim, generated files), without the whole system.
  perSystem =
    { system, ... }:
    {
      checks = lib.mapAttrs' (
        name: host:
        lib.nameValuePair "home-${name}" host.config.home-manager.users.${username}.home.activationPackage
      ) (lib.filterAttrs (_: host: host.pkgs.stdenv.hostPlatform.system == system) hosts);
    };
}
