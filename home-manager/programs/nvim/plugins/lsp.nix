{ pkgs, ... }:

{
  plugins.lsp = {
    enable = true;
    servers = {
      gopls = {
        enable = true;
        autostart = true;
        package =
          null; # ref: https://github.com/nix-community/nixvim/discussions/1442
        extraOptions.settings.gopls = {
          buildFlags = [ "-tags=unit,integration" ];
          gofumpt = true;
          codelenses = {
            gc_details = false;
            generate = true;
            regenerate_cgo = true;
            run_govulncheck = true;
            test = true;
            tidy = true;
            upgrade_dependency = true;
            vendor = true;
          };
          hints = {
            assignVariableTypes = true;
            compositeLiteralFields = true;
            compositeLiteralTypes = true;
            constantValues = true;
            functionTypeParameters = true;
            parameterNames = true;
            rangeVariableTypes = true;
          };
          analyses = {
            fieldalignment = true;
            nilness = true;
            unusedparams = true;
            unusedwrite = true;
            useany = true;
          };
          usePlaceholders = true;
          completeUnimported = true;
          staticcheck = true;
          directoryFilters =
            [ "-.git" "-.vscode" "-.idea" "-.vscode-test" "-node_modules" ];
          semanticTokens = true;
        };
      };
      yamlls.enable = true;
      pyright.enable = true;
    };
  };
  plugins.lsp-format = {
    enable = true;
    lspServersToEnable = "all";
  };
  plugins.none-ls = {
    enable = true;
    enableLspFormat = true;
    sources.formatting.nixfmt.enable = true;
    sources.formatting.gofumpt.enable = true;
  };
}
