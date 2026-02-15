-- ~/.config/nvim/lua/marc/switcheroo.lua
local M = {}

local has_telescope, telescope = pcall(require, "telescope.builtin")
if not has_telescope then
  vim.notify("switcheroo requires telescope.nvim", vim.log.levels.WARN)
  return M
end

local allowed_filetypes = { cpp = true, c = true, h = true, hpp = true }

-- fallback search using fd
local function fallback_search()
  local base = vim.fn.expand("%:t:r")
  local current = vim.fn.expand("%:t")
  local handle = io.popen(
    string.format("fd --type f --strip-cwd-prefix --color=never '^%s\\.(cpp|h|hpp)$'", base)
  )
  if not handle then return {} end

  local output = handle:read("*a")
  handle:close()

  local candidates = {}
  for file in string.gmatch(output, "[^\n]+") do
    if file ~= current then table.insert(candidates, file) end
  end
  return candidates
end

-- open file with given command (edit, split, vsplit)
local function open_file(path, open_cmd)
  open_cmd = open_cmd or "edit"
  vim.cmd(string.format("%s %s", open_cmd, vim.fn.fnameescape(path)))
end

-- telescope picker for multiple candidates
local function pick_file(files, open_cmd)
  if #files == 0 then
    vim.notify("No corresponding source/header found", vim.log.levels.WARN)
  elseif #files == 1 then
    open_file(files[1], open_cmd)
  else
    telescope.pickers.new({}, {
      prompt_title = "Switch source/header",
      finder = require("telescope.finders").new_table({ results = files }),
      sorter = require("telescope.config").values.generic_sorter({}),
      attach_mappings = function(prompt_bufnr, map)
        local actions = require("telescope.actions")
        local action_state = require("telescope.actions.state")
        actions.select_default:replace(function()
          actions.close(prompt_bufnr)
          local selection = action_state.get_selected_entry()
          open_file(selection[1], open_cmd)
        end)
        return true
      end,
    }):find()
  end
end

-- main function: optionally provide open_cmd ("edit", "split", "vsplit", "tabedit")
function M.switch(open_cmd)
  if not allowed_filetypes[vim.bo.filetype] then return end

  local params = vim.lsp.util.make_text_document_params()
  local handled = false

  for _, client in ipairs(vim.lsp.get_clients({ bufnr = vim.api.nvim_get_current_buf() })) do
    if client.name == "clangd" and client.supports_method("textDocument/switchSourceHeader") then
      client.request("textDocument/switchSourceHeader", params, function(_, result)
        if result then
          local file = vim.uri_to_fname(result)
          open_file(file, open_cmd)
        else
          pick_file(fallback_search(), open_cmd)
        end
      end, 0)
      handled = true
      break
    end
  end

  if not handled then
    pick_file(fallback_search(), open_cmd)
  end
end

-- keymaps

-- same window
vim.keymap.set("n", "<leader>ff", function() M.switch("edit") end)

-- splits
vim.keymap.set("n", "<leader>fH", function() M.switch("leftabove vsplit") end)
vim.keymap.set("n", "<leader>fJ", function() M.switch("rightbelow split") end)
vim.keymap.set("n", "<leader>fK", function() M.switch("leftabove split") end)
vim.keymap.set("n", "<leader>fL", function() M.switch("rightbelow vsplit") end)

return M
