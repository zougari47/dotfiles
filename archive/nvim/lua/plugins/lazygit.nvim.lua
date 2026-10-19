return {
  "kdheepak/lazygit.nvim",
  lazy = true,
  cmd = {
    "LazyGit",
    "LazyGitConfig",
    "LazyGitCurrentFile",
    "LazyGitFilter",
    "LazyGitFilterCurrentFile",
  },
  -- optional for floating window border decoration
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  -- setting the keybinding for LazyGit with 'keys' is recommended in
  -- order to load the plugin when the command is run for the first time
  init = function()
    vim.g.lazygit_floating_window_scaling_factor = 1

    -- layer lazygit.yml (layout overrides for Neovim only) on the default config
    vim.g.lazygit_use_custom_config_file_path = 1
    vim.g.lazygit_config_file_path = {
      vim.fn.expand("~/.config/lazygit/config.yml"),
      vim.fn.stdpath("config") .. "/lazygit.yml",
    }
  end,
  keys = {
    { "<leader>lg", "<cmd>LazyGit<cr>", desc = "LazyGit" },
  },
}
