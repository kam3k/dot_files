return {
  'nvim-treesitter/nvim-treesitter',
  -- We use 'lazy = false' to ensure it loads early enough
  lazy = false,
  config = function()
    -- Manually check where the plugin is installed
    -- Adjust this path if your plugin manager uses a different folder
    local plugin_path = vim.fn.stdpath("data") .. "/site/pack/deps/start/nvim-treesitter"
    vim.opt.runtimepath:append(plugin_path)

    local ok, configs = pcall(require, "nvim-treesitter.configs")
    if not ok then
      -- If it still fails, the plugin isn't on disk yet
      print("Treesitter not found on disk. Run :DepsInstall")
      return
    end

    -- Compatibility for Ubuntu 20.04 (No tree-sitter-cli)
    require('nvim-treesitter.install').prefer_git = true
    require('nvim-treesitter.install').compilers = { "gcc" }

    configs.setup({
      ensure_installed = { 'bash', 'c', 'cmake', 'cpp', 'lua', 'python' },
      highlight = { enable = true },
      disable = { "cpp" }, 
      additional_vim_regex_highlighting = false,
    })
  end
}
