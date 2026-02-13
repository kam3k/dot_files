return {
  'lewis6991/gitsigns.nvim',
  config = function()
    require('gitsigns').setup {
      on_attach = function(bufnr)
        local gitsigns = require('gitsigns')

        local function map(mode, l, r, opts)
          opts = opts or {}
          opts.buffer = bufnr
          vim.keymap.set(mode, l, r, opts)
        end

        -- Navigation
        map('n', ']c', function()
          if vim.wo.diff then
            vim.cmd.normal({']c', bang = true})
          else
            gitsigns.nav_hunk('next')
          end
        end)
        map('n', '[c', function()
          if vim.wo.diff then
            vim.cmd.normal({'[c', bang = true})
          else
            gitsigns.nav_hunk('prev')
          end
        end)

        -- Reset hunks
        map('n', '<leader>hu', gitsigns.reset_hunk)
        map('v', '<leader>hu', function()
          gitsigns.reset_hunk({ vim.fn.line('.'), vim.fn.line('v') })
        end)

        -- Blame
        map('n', "<leader>gb", gitsigns.blame)
      end
    }
  end
}
