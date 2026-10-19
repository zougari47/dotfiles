-- All keymaps. [mine] keys win; kickstart's defaults are kept below, disabled.

-- ===== [mine] =====
local map = vim.keymap.set

-- General (was: nvchad.mappings)
map("i", "<C-b>", "<ESC>^i", { desc = "move beginning of line" })
map("i", "<C-e>", "<End>", { desc = "move end of line" })
map("i", "<C-h>", "<Left>", { desc = "move left" })
map("i", "<C-l>", "<Right>", { desc = "move right" })
map("i", "<C-j>", "<Down>", { desc = "move down" })
map("i", "<C-k>", "<Up>", { desc = "move up" })

map("n", "<C-h>", "<C-w>h", { desc = "switch window left" })
map("n", "<C-l>", "<C-w>l", { desc = "switch window right" })
map("n", "<C-j>", "<C-w>j", { desc = "switch window down" })
map("n", "<C-k>", "<C-w>k", { desc = "switch window up" })

map("n", "<Esc>", "<cmd>noh<CR>", { desc = "general clear highlights" })

map("n", "<C-s>", "<cmd>w<CR>", { desc = "general save file" })
map("n", "<C-c>", "<cmd>%y+<CR>", { desc = "general copy whole file" })

map("n", "<leader>n", "<cmd>set nu!<CR>", { desc = "toggle line number" })
map("n", "<leader>rn", "<cmd>set rnu!<CR>", { desc = "toggle relative number" })

-- was: NvCheatsheet | now: search all keymaps
map("n", "<leader>ch", function()
  Snacks.picker.keymaps()
end, { desc = "search keymaps" })

-- was: nvchad.themes picker | now: Snacks colorschemes picker (choice is remembered, see lua/custom/theme.lua)
map("n", "<leader>th", function()
  Snacks.picker.colorschemes()
end, { desc = "pick theme" })

map({ "n", "x" }, "<leader>fm", function()
  require("conform").format { lsp_format = "fallback" }
end, { desc = "general format file" })

map("n", "<leader>ds", vim.diagnostic.setloclist, { desc = "LSP diagnostic loclist" })

-- Comment
map("n", "<leader>/", "gcc", { desc = "toggle comment", remap = true })
map("v", "<leader>/", "gc", { desc = "toggle comment", remap = true })

-- General (was: mappings.lua)
map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

map("n", "<leader>w", "<cmd> w <CR>", { desc = "Save file" })
map("n", "<leader>q", "<cmd> q <CR>", { desc = "Quit file" })

map("n", "<leader>o", "o<ESC>", { desc = "Insert new line below" })
map("n", "<leader>O", "O<ESC>", { desc = "Insert new line above" })

map("n", "<leader>nh", "<cmd>nohlsearch<CR>", { desc = "Clear search highlights" })

map("n", "<Esc>j", ":m .+1<CR>==", { desc = "Move line down" })
map("n", "<Esc>k", ":m .-2<CR>==", { desc = "Move line up" })
map("v", "<Esc>j", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
map("v", "<Esc>k", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

-- Buffers
-- was: tabufline next/prev | now: built-in buffer list (mini.tabline shows it)
map("n", "<tab>", "<cmd>bnext<CR>", { desc = "buffer goto next" })
map("n", "<S-tab>", "<cmd>bprevious<CR>", { desc = "buffer goto prev" })

-- was: tabufline.close_buffer() | now: Snacks.bufdelete (keeps the window open)
map("n", "<leader>x", function()
  Snacks.bufdelete()
end, { desc = "buffer close" })
-- was: tabufline.closeAllBufs(true) | now: Snacks.bufdelete.all
map("n", "<leader>bx", function()
  Snacks.bufdelete.all()
end, { desc = "Close all buffers including current" })
-- was: tabufline.closeAllBufs(false) | now: Snacks.bufdelete.other
map("n", "<leader>bX", function()
  Snacks.bufdelete.other()
end, { desc = "Close all buffers except current" })
map("n", "<leader>bn", "<cmd>enew<CR>", { desc = "New buffer" })
map("n", "<leader>br", "<cmd>checktime<CR>", { desc = "Refresh buffer" })

-- LSP
map("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "LSP code action" })
-- was: vim.lsp.buf.execute_command { command = "_typescript.organizeImports" } (deprecated, tsserver-only)
-- now: the standard organize-imports code action (works with vtsls)
map("n", "<leader>si", function()
  vim.lsp.buf.code_action {
    apply = true,
    context = { only = { "source.organizeImports" }, diagnostics = {} },
  }
end, { desc = "LSP Sort TypeScript imports" })

-- was: gl defined twice (rounded+focusable, then plain) | now: once, rounded+focusable
map("n", "gl", function()
  vim.diagnostic.open_float { border = "rounded", focusable = true }
end, { desc = "LSP Show floating diagnostic" })

-- was: nvchad.configs.lspconfig on_attach | now: same keys on LspAttach
-- was: <leader>wa / <leader>wr / <leader>wl | now: <leader>Wa / <leader>Wr / <leader>Wl (<leader>w is save)
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("mine-lsp-keymaps", { clear = true }),
  callback = function(event)
    local function opts(desc)
      return { buffer = event.buf, desc = "LSP " .. desc }
    end

    map("n", "gD", vim.lsp.buf.declaration, opts "Go to declaration")
    map("n", "gd", vim.lsp.buf.definition, opts "Go to definition")
    map("n", "<leader>Wa", vim.lsp.buf.add_workspace_folder, opts "Add workspace folder")
    map("n", "<leader>Wr", vim.lsp.buf.remove_workspace_folder, opts "Remove workspace folder")
    map("n", "<leader>Wl", function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, opts "List workspace folders")
    map("n", "<leader>D", vim.lsp.buf.type_definition, opts "Go to type definition")
    -- was: NvRenamer | now: built-in rename (prompt shown by Snacks input)
    map("n", "<leader>ra", vim.lsp.buf.rename, opts "Rename")
  end,
})

-- Explorer
-- was: NvimTreeToggle | now: Snacks explorer (calling it again closes it)
map("n", "<C-n>", function()
  Snacks.explorer()
end, { desc = "explorer toggle window" })

local function explorer()
  return Snacks.picker.get({ source = "explorer" })[1]
end

-- was: NvimTreeFocus | now: focus the explorer, opening it if needed
map("n", "<leader>e", function()
  local picker = explorer()
  if picker then
    picker:focus()
  else
    Snacks.explorer()
  end
end, { desc = "explorer focus window" })
-- was: nvim-tree api.node.collapse() | now: explorer_close action
map("n", "<leader>zc", function()
  local picker = explorer()
  if picker then
    picker:action "explorer_close"
  end
end, { desc = "Collapse current folder in explorer" })
-- was: nvim-tree api.tree.collapse_all() | now: explorer_close_all action
map("n", "<leader>ec", function()
  local picker = explorer()
  if picker then
    picker:action "explorer_close_all"
  end
end, { desc = "Collapse all folders in explorer" })

-- Find (was: Telescope | now: Snacks picker)
map("n", "<leader>ff", function()
  Snacks.picker.files()
end, { desc = "find files" })
map("n", "<leader>fa", function()
  Snacks.picker.files { hidden = true, ignored = true, follow = true }
end, { desc = "find all files" })
-- was: <leader>fw = current_buffer_fuzzy_find (your override of NvChad's live_grep)
map("n", "<leader>fw", function()
  Snacks.picker.lines()
end, { desc = "Find word in current buffer" })
map("n", "<leader>fz", function()
  Snacks.picker.lines()
end, { desc = "find in current buffer" })
map("n", "<leader>fW", function()
  Snacks.picker.grep()
end, { desc = "Find word in the entire project" })
map("n", "<leader>fb", function()
  Snacks.picker.buffers()
end, { desc = "find buffers" })
map("n", "<leader>fh", function()
  Snacks.picker.help()
end, { desc = "help page" })
map("n", "<leader>fo", function()
  Snacks.picker.recent()
end, { desc = "find oldfiles" })
map("n", "<leader>ma", function()
  Snacks.picker.marks()
end, { desc = "find marks" })
map("n", "<leader>cm", function()
  Snacks.picker.git_log()
end, { desc = "git commits" })
map("n", "<leader>gt", function()
  Snacks.picker.git_status()
end, { desc = "git status" })

-- Git
-- was: lazygit.nvim :LazyGit | now: Snacks lazygit
map("n", "<leader>lg", function()
  Snacks.lazygit()
end, { desc = "LazyGit" })

-- Terminal (was: nvchad.term | now: Snacks terminal)
map("t", "<C-x>", "<C-\\><C-N>", { desc = "terminal escape terminal mode" })

-- new terminals
map("n", "<leader>h", function()
  Snacks.terminal.open(nil, { win = { position = "bottom" } })
end, { desc = "terminal new horizontal term" })
map("n", "<leader>v", function()
  Snacks.terminal.open(nil, { win = { position = "right" } })
end, { desc = "terminal new vertical term" })

-- toggleable (each one keeps its own terminal, like the old ids vtoggleTerm/htoggleTerm/floatTerm)
map({ "n", "t" }, "<A-v>", function()
  Snacks.terminal.toggle(nil, { count = 101, win = { position = "right" } })
end, { desc = "terminal toggleable vertical term" })
map({ "n", "t" }, "<A-h>", function()
  Snacks.terminal.toggle(nil, { count = 102, win = { position = "bottom" } })
end, { desc = "terminal toggleable horizontal term" })
map({ "n", "t" }, "<A-i>", function()
  Snacks.terminal.toggle(nil, { count = 103, win = { position = "float" } })
end, { desc = "terminal toggle floating term" })

-- was: Telescope terms | now: pick from Snacks terminals
map("n", "<leader>pt", function()
  vim.ui.select(Snacks.terminal.list(), {
    prompt = "Terminals",
    format_item = function(term)
      return vim.api.nvim_buf_get_name(term.buf)
    end,
  }, function(term)
    if term then
      term:show():focus()
    end
  end)
end, { desc = "pick hidden term" })

-- WhichKey
-- was: <leader>wK / <leader>wk | now: <leader>WK / <leader>Wk (<leader>w is save)
map("n", "<leader>WK", "<cmd>WhichKey <CR>", { desc = "whichkey all keymaps" })
map("n", "<leader>Wk", function()
  vim.cmd("WhichKey " .. vim.fn.input "WhichKey: ")
end, { desc = "whichkey query lookup" })

-- Render Markdown
map("n", "<leader>rm", "<cmd>RenderMarkdown toggle<CR>", { desc = "Toggle Render Markdown" })
-- ===== end [mine] =====

-- ===== [kickstart] default keymaps (disabled) =====
-- vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')
-- vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })
-- vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })
-- vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
-- vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
-- vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
-- vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })
--
-- Telescope
-- vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
-- vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
-- vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
-- vim.keymap.set('n', '<leader>ss', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })
-- vim.keymap.set({ 'n', 'v' }, '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
-- vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
-- vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
-- vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
-- vim.keymap.set('n', '<leader>s.', builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
-- vim.keymap.set('n', '<leader>sc', builtin.commands, { desc = '[S]earch [C]ommands' })
-- vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })
-- vim.keymap.set('n', '<leader>/', function() builtin.current_buffer_fuzzy_find(...) end, { desc = '[/] Fuzzily search in current buffer' })
-- vim.keymap.set('n', '<leader>s/', function() builtin.live_grep { grep_open_files = true } end, { desc = '[S]earch [/] in Open Files' })
-- vim.keymap.set('n', '<leader>sn', function() builtin.find_files { cwd = vim.fn.stdpath 'config' } end, { desc = '[S]earch [N]eovim files' })
--
-- LSP (on LspAttach)
-- map('grr', builtin.lsp_references, '[G]oto [R]eferences')
-- map('gri', builtin.lsp_implementations, '[G]oto [I]mplementation')
-- map('grd', builtin.lsp_definitions, '[G]oto [D]efinition')
-- map('gO', builtin.lsp_document_symbols, 'Open Document Symbols')
-- map('gW', builtin.lsp_dynamic_workspace_symbols, 'Open Workspace Symbols')
-- map('grt', builtin.lsp_type_definitions, '[G]oto [T]ype Definition')
-- map('grn', vim.lsp.buf.rename, '[R]e[n]ame')
-- map('gra', vim.lsp.buf.code_action, '[G]oto Code [A]ction', { 'n', 'x' })
-- map('grD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
-- map('<leader>th', function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf }) end, '[T]oggle Inlay [H]ints')
--
-- Formatting
-- vim.keymap.set({ 'n', 'v' }, '<leader>f', function() require('conform').format { async = true } end, { desc = '[F]ormat buffer' })
-- ===== end [kickstart] =====
