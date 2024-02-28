return {
  "nvim-telescope/telescope.nvim",

  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  config = function()
    local builtin = require "telescope.builtin"
    require("telescope").setup {
      defaults = {},
      pickers = {
        --find_files = {theme = "ivy"},
        --diagnostics = {theme = "ivy"},
        --buffers = {theme = "ivy"},
        --git_files = {theme = "ivy"}
      },
      extensions = {
        -- ...
      },
    }
    vim.keymap.set("n", "<leader>pf", builtin.find_files, {})
    vim.keymap.set("n", "<leader>pd", builtin.diagnostics, {})
    vim.keymap.set("n", "<leader>pg", builtin.live_grep, {})
    vim.keymap.set("n", "<leader>ph", builtin.help_tags, {})
    vim.keymap.set("n", "<C-p>", builtin.git_files, {})

    require("telescope").load_extension "flutter"
  end,
}
