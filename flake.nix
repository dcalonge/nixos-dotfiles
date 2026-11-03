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

    betterfox = {
      url = "github:yokoffing/Betterfox";
      flake = false;
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
      vars = rec {
        user = "daniel";
        flakeDir = "/home/${user}/nixos-dotfiles";
      };

      mkHost =
        host:
        let
          hostVars = vars // {
            inherit host;
          };
        in
        nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs;
            vars = hostVars;
          };
          modules = [
            { nixpkgs.overlays = [ (import ./pkgs { inherit vars; }) ]; }
            ./configuration.nix
            ./hosts/${host}
            home-manager.nixosModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                backupFileExtension = "hm-backup";
                extraSpecialArgs = {
                  inherit inputs;
                  vars = hostVars;
                };
                users.${vars.user}.imports = [
                  ./home
                  ./hosts/${host}/home.nix
                ];
              };
            }
          ];
        };
    in
    {
      nixosConfigurations = nixpkgs.lib.genAttrs [
        "laptop-amd"
        "laptop-intel"
      ] mkHost;

      formatter = nixpkgs.lib.mapAttrs' (
        _: host: nixpkgs.lib.nameValuePair host.pkgs.stdenv.hostPlatform.system host.pkgs.nixfmt
      ) self.nixosConfigurations;
    };
}
