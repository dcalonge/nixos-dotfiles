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

        functions.fish_prompt = {
          description = "Write out the prompt";
          body = ''
            set -l last_pipestatus $pipestatus
            set -lx __fish_last_status $status # Export for __fish_print_pipestatus.

            if not set -q __fish_git_prompt_show_informative_status
                set -g __fish_git_prompt_show_informative_status 1
            end
            if not set -q __fish_git_prompt_hide_untrackedfiles
                set -g __fish_git_prompt_hide_untrackedfiles 1
            end
            if not set -q __fish_git_prompt_color_branch
                set -g __fish_git_prompt_color_branch magenta --bold
            end
            if not set -q __fish_git_prompt_showupstream
                set -g __fish_git_prompt_showupstream informative
            end
            if not set -q __fish_git_prompt_color_dirtystate
                set -g __fish_git_prompt_color_dirtystate blue
            end
            if not set -q __fish_git_prompt_color_stagedstate
                set -g __fish_git_prompt_color_stagedstate yellow
            end
            if not set -q __fish_git_prompt_color_invalidstate
                set -g __fish_git_prompt_color_invalidstate red
            end
            if not set -q __fish_git_prompt_color_untrackedfiles
                set -g __fish_git_prompt_color_untrackedfiles $fish_color_normal
            end
            if not set -q __fish_git_prompt_color_cleanstate
                set -g __fish_git_prompt_color_cleanstate green --bold
            end

            set -l color_cwd
            set -l suffix
            if functions -q fish_is_root_user; and fish_is_root_user
                if set -q fish_color_cwd_root
                    set color_cwd $fish_color_cwd_root
                else
                    set color_cwd $fish_color_cwd
                end
                set suffix '#'
            else
                set color_cwd $fish_color_cwd
                set suffix '>'
            end

            # PWD
            set_color --bold $fish_color_cwd
            echo -n " "
            echo -n (prompt_pwd --full-length-dirs 2)
            echo -n " $suffix "
            set_color normal
          '';
        };
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
