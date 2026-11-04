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

    nixvim = {
      url = "github:nix-community/nixvim";
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
            ./modules/nixos
            ./hosts/${host}/configuration.nix
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
                  ./modules/home-manager
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

      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixfmt;
    };
}
