return {
  "nvim-tree/nvim-tree.lua",
  opts = {
    view = {
      side = "right", -- set file explorer to the right
    },
    filters = {
      dotfiles = false,
    },
    actions = {
      open_file = {
        quit_on_open = true,
      },
    },
    notify = {
      threshold = vim.log.levels.ERROR, -- Only show error notifications
    },
  },
}
