return {
  'akinsho/bufferline.nvim',
  config = function()
    local bufferline = require('bufferline')
    bufferline.setup {
      options = {
        numbers = "ordinal",
        truncate_names = true,
        show_buffer_icons = false,
        buffer_close_icon = "",
        modified_icon = "[+]",
      }
    }
    for i = 1, 9 do
      vim.keymap.set('n', '<leader>' .. i, function()
        bufferline.go_to(i, true)
      end, { desc = "Go to buffer " .. i })
    end
  end,
}
