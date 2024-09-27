return {
  'thePrimeagen/harpoon',
  branch = 'harpoon2',
  dependencies = 'nvim-lua/plenary.nvim',
  config = function()
    local harpoon = require 'harpoon'
    --@diagnostic disable-next-line: missing-parameter
    harpoon:setup()
    local function map(lhs, rhs, opts)
      vim.keymap.set('n', lhs, rhs, opts or {})
    end
    map('<leader>ha', function()
      harpoon:list():replace_at(1)
    end)
    map('<leader>hs', function()
      harpoon:list():replace_at(2)
    end)
    map('<leader>hd', function()
      harpoon:list():replace_at(3)
    end)
    map('<leader>hf', function()
      harpoon:list():replace_at(4)
    end)
    map('<leader>aa', function()
      harpoon:list():add()
    end)
    map('<leader>l', function()
      harpoon.ui:toggle_quick_menu(harpoon:list())
    end)
    map('<leader>ja', function()
      harpoon:list():select(1)
    end)
    map('<leader>js', function()
      harpoon:list():select(2)
    end)
    map('<leader>jd', function()
      harpoon:list():select(3)
    end)
    map('<leader>jf', function()
      harpoon:list():select(4)
    end)
  end,
}
