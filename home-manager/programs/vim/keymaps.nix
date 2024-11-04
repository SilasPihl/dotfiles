{
  keymaps = [
    {
      mode = "n";
      key = "<leader>e";
      action = "<cmd>Neotree toggle<CR>";
      options = { desc = "Neotree"; };
    }
    {
      key = "<leader>g";
      mode = [ "n" ];
      action = "<cmd>LazyGit<CR>";
      options = { desc = "Lazygit"; };
    }
    {
      mode = "n";
      key = "<leader>t";
      action = ":FloatermToggle<CR>";
      options = { desc = "FloatermToggle"; };
    }
    {
      mode = "n";
      key = "<leader>z";
      action = "<cmd>Twilight<CR>";
      options = { desc = "Twilight"; };
    }
    {
      mode = "n";
      key = "<leader>Tf";
      action = "<cmd>lua require('neotest').run.run(vim.fn.expand('%'))<CR>";
      options = { desc = "Test file"; };
    }
    {
      mode = "n";
      key = "<leader>Tfb";
      action =
        "<cmd>lua require('neotest').run.run({vim.fn.expand('%'), strategy = 'dap'})<CR>";
      options = { desc = "Test file with debugger"; };
    }
    {
      mode = "n";
      key = "<leader>Tn";
      action = "<cmd>lua require('neotest').run.run()<CR>";
      options = { desc = "Test nearest"; };
    }
    {
      mode = "n";
      key = "<leader>Tl";
      action = "<cmd>lua require('neotest').run.run_last()<CR>";
      options = { desc = "Test last"; };
    }
    {
      mode = "n";
      key = "<leader>Tlb";
      action =
        "<cmd>lua require('neotest').run.run_last({ strategy = 'dap' })<CR>";
      options = { desc = "Test last with debugger"; };
    }
    {
      mode = "n";
      key = "<leader>Twf";
      action =
        "<cmd>lua require('neotest').watch.toggle(vim.fn.expand('%'))<CR>";
      options = { desc = "Watch file"; };
    }
    {
      mode = "n";
      key = "<leader>Twf";
      action = "<cmd>lua require('neotest').summary.toggle()<CR>";
      options = { desc = "Summary toggle"; };
    }
  ];
}
