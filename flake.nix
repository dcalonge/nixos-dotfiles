{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Only its Home Manager module is used; the compositor is pkgs.mango.
    mango = {
      url = "github:mangowm/mango";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    lazyvim = {
      url = "github:pfassina/lazyvim-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Not in nixpkgs
    helium = {
      url = "github:schembriaiden/helium-browser-nix-flake";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.nixpkgs-darwin.follows = "nixpkgs";
    };

    nix-flatpak.url = "github:gmodena/nix-flatpak";
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      ...
    }@inputs:
    let
      vars = {
        user = "daniel";
        host = "laptop";
        flakeDir = "/home/daniel/nixos-dotfiles";
      };
      host = self.nixosConfigurations.${vars.host};
    in
    {
      nixosConfigurations.${vars.host} = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs vars; };
        modules = [
          { nixpkgs.overlays = [ (import ./pkgs { inherit inputs vars; }) ]; }
          ./configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              backupFileExtension = "hm-backup";
              extraSpecialArgs = { inherit inputs vars; };
              users.${vars.user} = import ./home;
            };
          }
        ];
      };

      formatter.${host.pkgs.stdenv.hostPlatform.system} = host.pkgs.nixfmt;
    };
}
