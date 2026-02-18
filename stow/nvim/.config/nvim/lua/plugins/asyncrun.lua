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
      local build_dir = vim.fn.fnamemodify(vim.fn.getcwd(), ":h") .. "/build"
      -- Starts the build; stays in current window
      vim.cmd(string.format("AsyncRun -cwd=%s -mode=async ninja -j4", build_dir))
    end, { desc = "Build Project" })

    -- 4. Post-Build Logic (Auto-close on success, Alert on failure)
    vim.api.nvim_create_autocmd("User", {
      pattern = "AsyncRunStop",
      callback = function()
        -- g:asyncrun_code is 0 for success
        if vim.g.asyncrun_code == 0 then
          vim.cmd("cclose")
        end
      end,
    })
  end,
}
