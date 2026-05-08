return {
  {
    "sindrets/diffview.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    cmd = { "DiffviewOpen", "DiffviewFileHistory" },
    config = function()
      require("diffview").setup {
        enhanced_diff_hl = true,
        use_icons = true,
      }
    end,
  },
}
