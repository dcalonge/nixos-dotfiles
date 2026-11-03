{
  config,
  inputs,
  pkgs,
  ...
}:
let
  cfgHome = config.xdg.configHome;
in
{
  imports = [ inputs.lazyvim.homeManagerModules.default ];

  programs.firefox = {
    enable = true;

    nativeMessagingHosts = [ pkgs.pywalfox-native ];

    policies.ExtensionSettings =
      let
        amo = short: "https://addons.mozilla.org/firefox/downloads/latest/${short}/latest.xpi";
      in
      {
        "uBlock0@raymondhill.net" = {
          install_url = amo "ublock-origin";
          installation_mode = "force_installed";
        };
        "{446900e4-71c2-419f-a6a7-df9c091e268b}" = {
          install_url = amo "bitwarden-password-manager";
          installation_mode = "force_installed";
        };
        "pywalfox@frewacom.org" = {
          install_url = amo "pywalfox";
          installation_mode = "force_installed";
        };
        "sponsorBlocker@ajay.app" = {
          install_url = amo "sponsorblock";
          installation_mode = "force_installed";
        };
      };

    profiles.daniel = {
      id = 0;
      isDefault = true;
      extraConfig = builtins.readFile "${inputs.betterfox}/user.js";
    };
  };

  programs.foot = {
    enable = true;
    settings.main = {
      include = "${cfgHome}/foot/colors.ini";
      font = "JetBrainsMono Nerd Font:size=10";
      shell = "${config.programs.fish.package}/bin/fish";
      pad = "8x8";
    };
  };

  programs.fuzzel = {
    enable = true;
    settings = {
      main = {
        include = "${cfgHome}/fuzzel/colors.ini";
        dpi-aware = "no";
        width = 40;
        lines = 15;
        minimal-lines = 1;
        icons-enabled = "no";
        hide-prompt = "no";
        font = "JetbrainsMono Nerd Font:size=12:antialias=true:hinting=true";
        prompt = ''"> "'';
        terminal = "${config.programs.foot.package}/bin/foot";
        layer = "overlay";
        line-height = 32;
      };
      border = {
        width = 2;
        radius = 0;
      };
      key-bindings = {
        next = "none";
        prev = "none";
        next-with-wrap = "Down Control+n";
        prev-with-wrap = "Up Control+p";
      };
    };
  };

  services.mako = {
    enable = true;
    settings = {
      include = "${cfgHome}/mako/colors";
      font = "JetBrainsMono Nerd Font 10";
      anchor = "top-center";
      layer = "overlay";
      border-size = 1;
      group-by = "category,app-icon";
      default-timeout = 3000;
      margin = "30,0,0,0";

      "category=\"osd-text\"" = {
        history = 0;
        format = "<b>%s</b>\\n%b";
      };

      "category=\"osd\"" = {
        font = "JetbrainsMono Nerd Font 10";
        history = 0;
        format = "<b>%s</b>\\n%b";
      };
    };
  };

  programs.lazyvim = {
    enable = true;
    configFiles = ./nvim;
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

  programs.yazi = {
    enable = true;
    enableFishIntegration = true;
  };

  programs.zathura = {
    enable = true;
    extraConfig = "include ${cfgHome}/zathura/matugen-colors";
  };

  programs.mpv.enable = true;

  programs.imv.enable = true;

  programs.btop = {
    enable = true;
    settings = {
      color_theme = "matugen";
      rounded_corners = false;
      shown_boxes = "cpu mem net proc gpu0";
      update_ms = 1000;
      proc_sorting = "cpu direct";
      shown_gpus = "nvidia amd intel";
      save_config_on_exit = false;
    };
  };

  programs.opencode = {
    enable = true;
    settings = {
      model = "opencode/deepseek-v4.1-flash-free";
      small_model = "openrouter/google/gemma-4-26b-a4b-it:free";
      websearch = false;
      agents.title.model = "openrouter/google/gemma-4-26b-a4b-it:free";
      permissions = [
        {
          action = "websearch";
          resource = "*";
          effect = "allow";
        }
        {
          action = "webfetch";
          resource = "*";
          effect = "allow";
        }
      ];
      mcp.servers.youcom = {
        type = "remote";
        url = "https://api.you.com/mcp?profile=free";
      };
    };
    cli = {
      theme = {
        name = "system";
        mode = "system";
      };
      animations = true;
      session = {
        sidebar = "auto";
        thinking = "hide";
      };
      attention.notifications = true;
      terminal.copy = "select";
    };
    context = builtins.readFile ./opencode/AGENTS.md;
  };
}
