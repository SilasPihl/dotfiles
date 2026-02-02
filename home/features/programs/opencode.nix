{ pkgs, ... }:

let
  opencodeConfig = {
    "$schema" = "https://opencode.ai/config.json";
    mcp = {
      context7 = {
        type = "remote";
        url = "https://mcp.context7.com/mcp";
      };
    };
    plugin = [
      "opencode-anthropic-auth@latest"
    ];
  };
in
{
  home.packages = [ pkgs.opencode ];

  home.file.".config/opencode/opencode.json".text = builtins.toJSON opencodeConfig;
}
