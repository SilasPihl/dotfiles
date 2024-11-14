{ pkgs, ... }:

{
  plugins = {
    copilot-chat = {
      enable = true;
      settings = {
        auto_insert_mode = true;
        temperature = 0.0;
        window = {
          layout = "float";
          width = 0.5;
          height = 0.5;
        };
        question_header = "## Sebastian";
      };
    };
    copilot-cmp.enable = true;
    copilot-lua = {
      enable = true;
      suggestion.enabled = false;
      panel.enabled = false;
    };
  };
}
