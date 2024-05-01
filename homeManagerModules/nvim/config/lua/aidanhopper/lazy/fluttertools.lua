return {
  'akinsho/flutter-tools.nvim',
  config = function ()
    require("flutter-tools").setup {
      lsp = {
        color = {
          enabled = true,
          virtual_text = true,
        }
      }
    } -- use defaults
    vim.api.nvim_create_autocmd('BufWritePre', {
      desc = 'Hot reload for flutter',
      group = vim.api.nvim_create_augroup('reload_on_save', { clear = true }),
      callback = function (opts)
        if vim.bo[opts.buf].filetype == 'dart' then
          vim.cmd 'FlutterReload'
        end
      end,
    })
  end
}
