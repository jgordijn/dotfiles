-- this ads the prettier command to the command line
local prettier_cmd = vim.fn.expand("~/.local/share/nvim/mason/bin/prettier")

-- Set up a command to format the current buffer
vim.api.nvim_create_user_command("Prettier", function()
  local current_file = vim.api.nvim_buf_get_name(0)
  local cmd = prettier_cmd .. " --write " .. current_file
  vim.fn.jobstart(cmd, {
    on_exit = function(_, code)
      if code == 0 then
        vim.cmd("e!") -- Reload the file
        print("Prettier formatting completed")
      else
        print("Prettier failed with code: " .. code)
      end
    end
  })
end, {})

vim.api.nvim_set_keymap("n", "<leader>pf", ":Prettier<CR>", { desc = "Prettier Format", noremap = true, silent = true })
return {}
