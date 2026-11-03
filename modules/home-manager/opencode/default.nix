{
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
    context = builtins.readFile ./AGENTS.md;
  };
}
