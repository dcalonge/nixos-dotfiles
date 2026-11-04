{ inputs, pkgs, ... }:
{
  imports = [
    inputs.nixvim.homeModules.nixvim
    ./coding.nix
    ./editor.nix
    ./keymaps.nix
    ./options.nix
    ./ui.nix
  ];

  programs.nixvim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;

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
