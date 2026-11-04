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
    };

    betterfox = {
      url = "github:yokoffing/Betterfox";
      flake = false;
    };

    nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=latest";
  };

  outputs =
    {
      nixpkgs,
      home-manager,
      ...
    }@inputs:
    let
      inherit (nixpkgs) lib;

      vars = rec {
        user = "daniel";
        flakeDir = "/home/${user}/nixos-dotfiles";
      };

      importDir =
        dir:
        let
          isModule =
            name: type:
            name != "default.nix"
            && (
              (type == "regular" && lib.hasSuffix ".nix" name)
              || (type == "directory" && builtins.pathExists (dir + "/${name}/default.nix"))
            );
        in
        lib.mapAttrsToList (name: _: dir + "/${name}") (
          lib.filterAttrs isModule (builtins.readDir dir)
        );

      hosts = lib.attrNames (
        lib.filterAttrs (_: type: type == "directory") (builtins.readDir ./hosts)
      );

      mkHost =
        host:
        let
          hostVars = vars // {
            inherit host;
          };
        in
        lib.nixosSystem {
          specialArgs = {
            inherit inputs importDir;
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
                  inherit inputs importDir;
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
      nixosConfigurations = lib.genAttrs hosts mkHost;

      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixfmt;
    };
}
