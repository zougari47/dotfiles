-- Remembers the last colorscheme you picked (e.g. with :lua Snacks.picker.colorschemes()
-- or :colorscheme <name>) and loads it again on the next start.
-- Saved in ~/.local/state/nvim/colorscheme. Delete that file to go back to the default theme.

local file = vim.fn.stdpath "state" .. "/colorscheme"

-- Transparent background on every colorscheme, so Alacritty's opacity shows through
-- (floats cover the Snacks picker, explorer and lazygit)
vim.api.nvim_create_autocmd("ColorScheme", {
  callback = function()
    for _, group in ipairs { "Normal", "NormalNC", "NormalFloat", "FloatBorder", "SignColumn", "EndOfBuffer" } do
      vim.api.nvim_set_hl(0, group, { fg = vim.api.nvim_get_hl(0, { name = group, link = false }).fg })
    end
  end,
})

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
