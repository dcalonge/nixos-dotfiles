{ inputs, ... }:
{
  flake.modules.nixos.desktop = {
    imports = [ inputs.nix-flatpak.nixosModules.nix-flatpak ];

    services.flatpak = {
      enable = true;
      remotes = [
        {
          name = "flathub";
          location = "https://dl.flathub.org/repo/flathub.flatpakrepo";
        }
      ];
      packages = [ "com.stremio.Stremio" ];
    };
  };
}
