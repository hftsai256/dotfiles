local utils = {}
local api = vim.api

utils.exec = setmetatable({}, {
  __index = function(t, k)
    local command = k:gsub("_$", "!")
    local f = function(...)
      return api.nvim_command(table.concat(vim.tbl_flatten({ command, ... }), " "))
    end
    rawset(t, k, f)
    return f
  end,
})

return utils
