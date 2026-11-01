local M = {}

---@param opts dired.user_config?
function M.setup(opts)
   vim.api.nvim_set_current_dir(vim.fn.expand('%:p:h'))

   require('dired.config').setup(opts or {})

   local dired_group = vim.api.nvim_create_augroup('dired', { clear = true })

   if require('dired.config').settings.auto_open then
      vim.api.nvim_create_autocmd('BufEnter', {
         pattern = '*',
         callback = function(args)
            local buf = args.buf
            local name = vim.api.nvim_buf_get_name(buf)

            if vim.fn.isdirectory(name) == 1 and not vim.bo[buf].modified then
               require('dired.render').show()
            end
         end,
         group = dired_group,
      })
   end

   vim.api.nvim_create_autocmd('VimEnter', {
      pattern = '*',
      callback = function()
         pcall(vim.api.nvim_clear_autocmds, { group = 'FileExplorer' })
         pcall(vim.api.nvim_clear_autocmds, { group = 'NERDTreeHijackNetrw' })
      end,
      group = dired_group,
   })

   pcall(vim.api.nvim_clear_autocmds, { group = 'FileExplorer' })
end

return M
