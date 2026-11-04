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

          set --global fish_color_autosuggestion 585858
          set --global fish_color_cancel --reverse
          set --global fish_color_command a1b56c
          set --global fish_color_comment f7ca88
          set --global fish_color_cwd white
          set --global fish_color_cwd_root red
          set --global fish_color_end ba8baf
          set --global fish_color_error ab4642
          set --global fish_color_escape 86c1b9
          set --global fish_color_history_current --bold
          set --global fish_color_host normal
          set --global fish_color_host_remote
          set --global fish_color_keyword
          set --global fish_color_match 7cafc2
          set --global fish_color_normal normal
          set --global fish_color_operator 7cafc2
          set --global fish_color_option
          set --global fish_color_param d8d8d8
          set --global fish_color_quote f7ca88
          set --global fish_color_redirection d8d8d8
          set --global fish_color_search_match white --background=brblack
          set --global fish_color_selection white --bold --background=brblack
          set --global fish_color_status red
          set --global fish_color_user brgreen
          set --global fish_color_valid_path --underline
          set --global fish_pager_color_background
          set --global fish_pager_color_completion normal
          set --global fish_pager_color_description B3A06D
          set --global fish_pager_color_prefix normal --bold --underline
          set --global fish_pager_color_progress brwhite --background=cyan
          set --global fish_pager_color_secondary_background
          set --global fish_pager_color_secondary_completion
          set --global fish_pager_color_secondary_description
          set --global fish_pager_color_secondary_prefix
          set --global fish_pager_color_selected_background --background=brblack
          set --global fish_pager_color_selected_completion
          set --global fish_pager_color_selected_description
          set --global fish_pager_color_selected_prefix
        '';

        shellAbbrs = {
          fu = "flatpak update";
          fi = "flatpak install";
          fr = "flatpak uninstall";
          fs = "flatpak search";

          nos = "nh os switch";
          # Inputs are updated by the weekly GitHub workflow; this pulls its lock
          nosu = "git -C ${flakeDir} pull --ff-only && nh os switch";
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
