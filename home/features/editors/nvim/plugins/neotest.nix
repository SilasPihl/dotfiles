{ pkgs, ... }:

{
  plugins.neotest = {
    enable = true;
    adapters.go = {
      enable = true;
      settings = { testFlags = [ "-tags=unit,integration" ]; };
    };
  };

  keymaps = [
    {
      mode = "n";
      key = "<leader>Tf";
      action = "<cmd>lua require('neotest').run.run(vim.fn.expand('%'))<CR>";
      options.desc = "Test file";
    }
    {
      mode = "n";
      key = "<leader>Td";
      action =
        "<cmd>lua require('neotest').run.run({vim.fn.expand('%'), strategy = 'dap'})<CR>";
      options.desc = "Test file with debugger";
    }
    {
      mode = "n";
      key = "<leader>Tn";
      action = "<cmd>lua require('neotest').run.run()<CR>";
      options.desc = "Test nearest";
    }
    {
      mode = "n";
      key = "<leader>Tl";
      action = "<cmd>lua require('neotest').run.run_last()<CR>";
      options.desc = "Test last";
    }
    {
      mode = "n";
      key = "<leader>Tw";
      action =
        "<cmd>lua require('neotest').watch.toggle(vim.fn.expand('%'))<CR>";
      options.desc = "Watch file";
    }
    {
      mode = "n";
      key = "<leader>Ts";
      action = "<cmd>lua require('neotest').summary.toggle()<CR>";
      options.desc = "Summary toggle";
    }
  ];
}
