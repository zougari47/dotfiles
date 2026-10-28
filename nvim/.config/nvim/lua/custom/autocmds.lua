-- Autocommands

-- ===== [kickstart] =====
vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking (copying) text",
  group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})
-- ===== end [kickstart] =====

-- ===== [mine] =====
vim.filetype.add { extension = { mdx = "markdown" } }

-- was: Nvdash when the last buffer is closed (used tabufline's vim.t.bufs)
-- now: Snacks dashboard when only one empty buffer is left
vim.api.nvim_create_autocmd("BufDelete", {
  group = vim.api.nvim_create_augroup("mine-dashboard-on-empty", { clear = true }),
  callback = function(args)
    vim.schedule(function()
      local bufs = vim.tbl_filter(function(b)
        return b ~= args.buf and vim.api.nvim_buf_is_valid(b) and vim.bo[b].buflisted
      end, vim.api.nvim_list_bufs())
      if #bufs == 1 and vim.api.nvim_buf_get_name(bufs[1]) == "" and vim.bo[bufs[1]].filetype == "" then
        -- open it in the empty buffer's window, like at startup: a bare Snacks.dashboard() is a
        -- full-screen float that hides the tabline/statusline, and the picker opens files inside it
        local win = vim.fn.bufwinid(bufs[1])
        if win ~= -1 then
          Snacks.dashboard { buf = bufs[1], win = win }
        end
      end
    end)
  end,
})
-- ===== end [mine] =====
