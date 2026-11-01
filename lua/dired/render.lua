local M = {}

---@param path string
---@param opts dired.render.show_opts
---@return string[]
local function ls(path, opts)
   local cmd = {
      'ls',
      path,
      '-D',
   }

   if opts.show_hidden then
      table.insert(cmd, '-a')
   end
   if not opts.show_dot then
      table.insert(cmd, '-A')
   end
   if opts.print_author then
      table.insert(cmd, '--author')
   end
   if opts.directories_first then
      table.insert(cmd, '--group-directories-first')
   end
   if not opts.print_group then
      table.insert(cmd, '-G')
   end
   if opts.human_readable then
      table.insert(cmd, '-h')
   end
   table.insert(cmd, '--sort=' .. opts.sort_by)

   local res = vim.split(vim.system(cmd):wait().stdout, '\n', { trimempty = true })
   table.insert(res, 1, path)
   return res
end

---Render output of ls command
---@param path? string
---@param opts? dired.render.show_opts
function M.show(path, opts)
   local source_buf = vim.api.nvim_get_current_buf()
   local source_name = vim.api.nvim_buf_get_name(source_buf)

   if not path then
      if vim.bo[source_buf].filetype == 'dired' and vim.b[source_buf].dired_path then
         path = vim.b[source_buf].dired_path
      elseif source_name == '' or vim.bo[source_buf].buftype == 'terminal' or source_name:match('^term://') then
         path = vim.fn.getcwd()
      elseif vim.fn.isdirectory(source_name) == 1 then
         path = source_name
      else
         path = vim.fn.fnamemodify(source_name, ':p:h')
      end
   end

   path = vim.fs.normalize(path)
   opts = vim.tbl_extend('keep', opts or {}, require('dired.config').settings)

   local dired_name = 'dired://' .. path
   local buf = vim.fn.bufnr(dired_name)
   if buf == -1 then
      buf = vim.api.nvim_create_buf(true, false)
      vim.api.nvim_buf_set_name(buf, dired_name)
   end

   local altbuf = vim.fn.bufnr('#')
   vim.api.nvim_win_set_buf(0, buf)

   vim.bo[buf].filetype = 'dired'
   vim.bo[buf].swapfile = false
   vim.bo[buf].buftype = 'acwrite'
   vim.bo[buf].bufhidden = 'hide'
   vim.bo[buf].modifiable = true
   vim.b[buf].dired_path = path

   if altbuf ~= -1 and altbuf ~= buf then
      vim.fn.setreg('#', altbuf)
   end

   local rows = ls(path, opts)
   table.remove(rows, #rows)
   table.remove(rows, #rows)

   vim.api.nvim_buf_set_lines(buf, 0, -1, false, rows)
   vim.api.nvim_win_set_cursor(0, { 3, 2 }) --TODO

   vim.bo[buf].modified = false
   vim.bo[buf].modifiable = false
end

return M
