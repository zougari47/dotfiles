-- Remembers the last colorscheme you picked (e.g. with :lua Snacks.picker.colorschemes()
-- or :colorscheme <name>) and loads it again on the next start.
-- Saved in ~/.local/state/nvim/colorscheme. Delete that file to go back to the default theme.

local file = vim.fn.stdpath "state" .. "/colorscheme"

local ok, lines = pcall(vim.fn.readfile, file)
if ok and lines[1] and lines[1] ~= "" then
  pcall(vim.cmd.colorscheme, lines[1])
end

vim.api.nvim_create_autocmd("ColorScheme", {
  group = vim.api.nvim_create_augroup("mine-remember-colorscheme", { clear = true }),
  callback = function(args)
    vim.fn.mkdir(vim.fn.fnamemodify(file, ":h"), "p")
    vim.fn.writefile({ args.match }, file)
  end,
})
