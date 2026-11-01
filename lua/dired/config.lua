local M = {}

---@type dired.user_config
M.default = {
   settings = {
      auto_open = true,
      show_hidden = true,
      show_dot = false,
      show_backups = false,
      print_group = true,
      print_author = false,
      human_readable = true,
      enable_colors = true,
      directories_first = true,
      sort_by = 'name',
   },
   keymaps = {
      show = '<C-e>',
   },
   colors = {},
}

---@type dired.user_config.settings?
M.settings = nil

---@type dired.user_config.keymaps?
M.keymaps = nil

---@type dired.user_config.colors?
M.colors = nil

---@param config dired.user_config
local function validate_config(config)
   local function validate_bool(name, value)
      vim.validate('opts.settings.' .. name, value, 'boolean', true, 'was expected to be boolean')
   end

   local set = config.settings

   validate_bool('auto_open', set.auto_open)
   validate_bool('show_hidden', set.show_hidden)
   validate_bool('show_dot', set.show_dot)
   validate_bool('show_backups', set.show_backups)
   validate_bool('print_group', set.print_group)
   validate_bool('print_author', set.print_author)
   validate_bool('human_readable', set.human_readable)
   validate_bool('enable_colors', set.enable_colors)
   validate_bool('directories_first', set.directories_first)

   vim.validate('opts.settings.sort_by', set.sort_by, function(a)
      return a:match('name|time|size|width')
   end, true, 'expected to be "name" | "time" | "size" | "width"')
end

---@param keymaps dired.user_config.keymaps
local function assign_keymaps(keymaps)
   local function opt(desc, bufnr)
      return { unique = true, silent = true, noremap = true, buffer = bufnr, desc = 'Dired ' .. desc }
   end
   local map = vim.keymap.set

   map('n', keymaps.show, function()
      require('dired.render').show()
   end, opt('Open'))

   vim.api.nvim_create_autocmd('FileType', {
      pattern = 'dired',
      callback = function(args)
         -- map(...)
      end,
   })
end

---Handles config passed by the user
---@param config dired.user_config
function M.setup(config)
   if config then
      local errors = validate_config(config)
      if errors then
         for _, err in ipairs(errors) do
            vim.notify(err, vim.log.levels.ERROR)
         end
      end
   end

   config = vim.tbl_deep_extend('force', M.default, config)

   M.settings = config.settings
   M.keymaps = config.keymaps
   M.colors = config.colors

   assign_keymaps(M.keymaps)
end

return M
