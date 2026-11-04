{ config, inputs, ... }:
let
  nixvim = config.flake.modules.nixvim.neovim;
in
{
  flake.modules.homeManager.base =
    { pkgs, ... }:
    {
      imports = [ inputs.nixvim.homeModules.nixvim ];

      programs.nixvim = {
        enable = true;
        defaultEditor = true;
        viAlias = true;
        vimAlias = true;

        # The Nixvim settings from the other files in this folder
        imports = [ nixvim ];

        colorscheme = "mini-matugen";
        extraFiles."colors/mini-matugen.lua".source = ./files/colors/mini-matugen.lua;
        extraConfigLua = builtins.readFile ./files/config/autocmds.lua;

        extraPackages = with pkgs; [
          fd
          lazygit
          ripgrep
        ];
      };
    };
}
