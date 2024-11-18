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
          width = 0.75;
          height = 0.75;
        };
        question_header = "## Sebastian";
        defaults = {
          Commit = {
            prompt =
              "Write commit message for the change with commitizen convention. Make sure the title has maximum 50 characters and message is wrapped at 72 characters. Wrap the whole message in code block with language gitcommit.";
            selection = "require('CopilotChat.select').gitdiff";
          };
          CommitStaged = {
            prompt =
              "Write commit message for the change with commitizen convention. Make sure the title has maximum 50 characters and message is wrapped at 72 characters. Wrap the whole message in code block with language gitcommit.";
            selection = ''
              function(source)
                return select.gitdiff(source, true)
              end
            '';
          };
          Docs = {
            prompt = " Please add documentation comment for the selection.";
          };
          Explain = {
            prompt =
              " Write an explanation for the active selection as paragraphs of text.";
          };
          Fix = {
            prompt =
              " There is a problem in this code. Rewrite the code to show it with the bug fixed.";
          };
          FixDiagnostic = {
            prompt =
              "Please assist with the following diagnostic issue in file:";
            selection = "require('CopilotChat.select').diagnostics";
          };
          Optimize = {
            prompt =
              " Optimize the selected code to improve performance and readablilty.";
          };
          Review = {
            callback = ''
              function(response, source)
                -- see config.lua for implementation
              end
            '';
            prompt = " Review the selected code.";
          };
          Tests = { prompt = " Please generate tests for my code."; };
        };
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
