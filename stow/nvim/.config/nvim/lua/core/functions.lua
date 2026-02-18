function switch_source_header()
  local bufnr = vim.api.nvim_get_current_buf()
  local filename = vim.fn.expand("%:t:r")
  local extension = vim.fn.expand("%:e")
  local full_name = vim.fn.expand("%:t")

  local target_exts = {}
  if extension == "cpp" or extension == "c" or extension == "cc" then
    target_exts = { "h", "hpp" }
  elseif extension == "h" or extension == "hpp" then
    target_exts = { "cpp", "cc" }
  else
    print("Not a C++ file")
    return
  end

  local search_regex = "^" .. filename .. "\\.(" .. table.concat(target_exts, "|") .. ")$"

  require('telescope.builtin').find_files({
    prompt_title = "Switch to counterpart (" .. filename .. ")",
    find_command = { "fdfind", search_regex, "-E", full_name },
  })
end

vim.keymap.set("n", "<leader>ff", switch_source_header, { desc = "Telescope switch source/header" })
