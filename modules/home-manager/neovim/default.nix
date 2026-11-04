{
  inputs,
  importDir,
  pkgs,
  ...
}:
{
  imports = [ inputs.nixvim.homeModules.nixvim ];

  programs.nixvim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;

    imports = importDir ./.;

    colorscheme = "mini-matugen";
    extraFiles."colors/mini-matugen.lua".source = ./files/colors/mini-matugen.lua;
    extraConfigLua = builtins.readFile ./files/config/autocmds.lua;

    extraPackages = with pkgs; [
      fd
      lazygit
      ripgrep
    ];
  };
}
