{ pkgs, ... }:

{
  plugins.neo-tree = {
    enable = true;
    autoCleanAfterSessionRestore = true;
    closeIfLastWindow = true;
    window = {
      position = "left";
      autoExpandWidth = true;
    };
    filesystem = {
      filteredItems = {
        hideHidden = false;
        hideDotfiles = false;
        forceVisibleInEmptyFolder = true;
        hideGitignored = false;
      };
    };
    defaultComponentConfigs = {
      diagnostics = {
        symbols = {
          hint = "";
          info = "";
          warn = "";
          error = "";
        };
        highlights = {
          hint = "DiagnosticSignHint";
          info = "DiagnosticSignInfo";
          warn = "DiagnosticSignWarn";
          error = "DiagnosticSignError";
        };
      };
    };
  };
}
