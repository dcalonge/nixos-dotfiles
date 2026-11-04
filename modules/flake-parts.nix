{ inputs, ... }:
{
  # Provides flake.modules.<class>.<name>, where every feature module lives.
  imports = [ inputs.flake-parts.flakeModules.modules ];

  systems = [ "x86_64-linux" ];

  perSystem =
    { pkgs, ... }:
    {
      formatter = pkgs.nixfmt;
    };
}
