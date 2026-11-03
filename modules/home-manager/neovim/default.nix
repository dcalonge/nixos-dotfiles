{ inputs, pkgs, ... }:
{
  imports = [ inputs.lazyvim.homeManagerModules.default ];

  programs.lazyvim = {
    enable = true;
    configFiles = ./files;
    pluginSource = "nixpkgs";
    # mini.nvim by store path: lazyvim-nix can't detect plugins in configFiles
    plugins.colorscheme = ''
      return {
        { "LazyVim/LazyVim", opts = { colorscheme = "mini-matugen" } },
        { dir = "${pkgs.vimPlugins.mini-nvim}", name = "mini.nvim", lazy = false, priority = 1000 },
      }
    '';
    extraPackages = with pkgs; [
      lua-language-server
      stylua
      shfmt
    ];
  };
  programs.neovim.defaultEditor = true;
}
