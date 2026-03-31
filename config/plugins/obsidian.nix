{ config, ... }:
{
  plugins.obsidian = {
    enable = true;
    settings = {
      workspaces = [
        {
          name = "Main";
          path = "~/Notes";
        }
      ];
      daily_notes = {
        folder = "Daily";
        template = "templates/daily.template";
      };
    };
  };
}
