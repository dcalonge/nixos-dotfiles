{ config, ... }:
let
  inherit (config) flakeDir;
in
{
  flake.modules.nixos.base =
    { pkgs, ... }:
    {
      programs.fish.enable = true;
      environment.binsh = "${pkgs.dash}/bin/dash";
    };

  flake.modules.homeManager.base =
    { pkgs, ... }:
    {
      programs.fish = {
        enable = true;

        interactiveShellInit = ''
          set -g fish_greeting
          ${pkgs.fortune}/bin/fortune -s | ${pkgs.cowsay}/bin/cowsay -f tux

          set -g __fish_git_prompt_show_informative_status 1
          set -g __fish_git_prompt_hide_untrackedfiles 1
          set -g __fish_git_prompt_showupstream informative
        '';

        shellAbbrs = {
          fu = "flatpak update";
          fi = "flatpak install";
          fr = "flatpak uninstall";
          fs = "flatpak search";

          nos = "nh os switch";
          nosu = "git -C ${flakeDir} fetch --quiet; git -C ${flakeDir} reset --hard '@{upstream}' && nh os switch";
          nhs = "nh search";
          ns = {
            expansion = "nix shell nixpkgs#%";
            setCursor = true;
          };
          nr = {
            expansion = "nix run nixpkgs#%";
            setCursor = true;
          };

          v = "nvim";
        };

        shellAliases.cat = "bat";

        functions.prompt_login.body = "true";
      };

      programs.eza = {
        enable = true;
        enableFishIntegration = true;
        icons = "auto";
        colors = "always";
        extraOptions = [
          "-a"
          "--group-directories-first"
        ];
      };

      programs.bat.enable = true;
      programs.gh.enable = true;
      programs.lazygit.enable = true;
      programs.fd.enable = true;
      programs.jq.enable = true;
      programs.fzf = {
        enable = true;
        enableFishIntegration = false;
        enableBashIntegration = false;
      };

      home.packages = with pkgs; [
        fortune
        cowsay
        tree-sitter
      ];
    };
}
