vim.o.termguicolors = true
vim.cmd [[ colorscheme catppuccin ]]
-- Transparency
vim.api.nvim_command('hi Normal ctermbg=none guibg=none')
vim.api.nvim_command('hi NormalSB ctermbg=none guibg=none')
vim.api.nvim_command('hi NormalNC ctermbg=none guibg=none')
vim.api.nvim_command('hi NvimTreeNormal ctermbg=none guibg=none')
vim.api.nvim_command('hi NvimTreeNormalNC ctermbg=none guibg=none')
