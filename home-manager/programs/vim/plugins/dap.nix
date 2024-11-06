{ pkgs, ... }:

{
  plugins.dap = {
    enable = true;
    adapters = { };
    signs = {
      dapBreakpoint = {
        text = "●";
        texthl = "DapBreakpoint";
      };
      dapBreakpointCondition = {
        text = "●";
        texthl = "DapBreakpointCondition";
      };
      dapLogPoint = {
        text = "◆";
        texthl = "DapLogPoint";
      };
    };
    extensions = {
      dap-go = {
        enable = true;
        delve.path = "${pkgs.delve}/bin/dlv";
      };
      dap-ui = { enable = true; };
      dap-virtual-text = { enable = true; };
    };
  };

  keymaps = [
    {
      mode = "n";
      key = "<leader>dt";
      action = ":DapUiToggle<CR>";
      options.desc = "Dap UI toggle";
    }
    {
      mode = "n";
      key = "<leader>db";
      action = ":DapToggleBreakpoint<CR>";
      options.desc = "Dap toggle breakpoint";
    }
    {
      mode = "n";
      key = "<leader>dc";
      action = ":DapContinue<CR>";
      options.desc = "Dap continue";
    }
    {
      mode = "n";
      key = "<leader>dr";
      action = ":lua require('dapui').open({reset=true})<CR>";
      options.desc = "Dap restart";
    }
  ];
}
