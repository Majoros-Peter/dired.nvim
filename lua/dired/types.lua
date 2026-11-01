---@meta
error('This file should not be included!')

--#region User Config

---@class dired.user_config
---@field settings dired.user_config.settings
---@field keymaps dired.user_config.keymaps
---@field colors dired.user_config.colors

---@class dired.user_config.settings
---@field auto_open boolean
---@field show_hidden boolean                         -- show entries starting with .
---@field show_dot boolean                            -- list implied . and ..
---@field show_backups boolean                        -- list implied entries ending with ~
---@field print_group boolean                         -- in a long listing, don't print group names
---@field print_author boolean                        -- print the author of each file
---@field human_readable boolean                      -- print sizes like 1K 234M 2G etc.
---@field enable_colors boolean                       -- color the output
---@field directories_first boolean                   -- group directories before files
---@field sort_by "name" | "time" | "size" | "width"  -- sort entries

---@class dired.user_config.keymaps
---@field show string

---@class dired.user_config.colors

--#endregion

---@class dired.render.show_opts
---@field show_hidden? boolean                         -- show entries starting with .
---@field show_dot? boolean                            -- list implied . and ..
---@field show_backups? boolean                        -- list implied entries ending with ~
---@field print_group? boolean                         -- in a long listing, don't print group names
---@field print_author? boolean                        -- print the author of each file
---@field human_readable? boolean                      -- print sizes like 1K 234M 2G etc.
---@field enable_colors? boolean                       -- color the output
---@field directories_first? boolean                   -- group directories before files
---@field sort_by? "name" | "time" | "size" | "width"  -- sort entries
