return {
  "skywind3000/asyncrun.vim",
  config = function()
    -- 1. Configuration
    vim.g.asyncrun_open = 10 -- Open QF window to height 10
    vim.o.errorformat = [[%f:%l:%c: %t%*[^:]: %m]]

    -- 2. Toggle Quickfix
    vim.keymap.set("n", "<leader><leader>", function()
      local qf_exists = false
      for _, win in pairs(vim.fn.getwininfo()) do
        if win["quickfix"] == 1 then qf_exists = true end
      end
      if qf_exists then vim.cmd("cclose") else vim.cmd("copen") end
    end, { desc = "Toggle Quickfix" })

    -- 3. Build Command
    vim.keymap.set("n", "<leader>b", function()
      -- Dynamically grab the true root directory that clangd is currently indexing
      local lsp_clients = vim.lsp.get_clients({ name = "clangd" })
      local lsp_root = (lsp_clients and lsp_clients[1]) and lsp_clients[1].root_dir or nil

      -- Fallback: If LSP isn't ready yet, drop back to Neovim's current working directory
      local final_cwd = lsp_root or vim.fn.getcwd()

      -- Execute ebm inside an interactive Zsh shell, explicitly locked to the true root folder
      local cmd = string.format("AsyncRun -cwd=%s -mode=async zsh -ic 'ebm'", final_cwd)
      vim.cmd(cmd)
    end, { desc = "Build Project via ebm" })

    -- 4. Post-Build Logic (Auto-close on success)
    vim.api.nvim_create_autocmd("User", {
      pattern = "AsyncRunStop",
      callback = function()
        if vim.g.asyncrun_code == 0 then
          vim.cmd("cclose")
        end
      end,
    })
  end,
}
