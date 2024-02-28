return {
  'folke/zen-mode.nvim',
  config = function ()
    require'zen-mode'.setup {
      window = {
        width = 85,
        backdrop = 1,
        options = {
          cursorline = true,
          cursorcolumn = true,
        },
      },
      plugins = {
        options = {
          enabled = true,
          ruler = true,
          showcmd = true,
          laststatus = 3,
        },
      },
    }
    vim.keymap.set("n", "<leader>zz", ":Zen<CR>", {silent=true})
  end
}
