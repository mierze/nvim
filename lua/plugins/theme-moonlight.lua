return {
  'shaunsingh/moonlight.nvim',
  lazy = false,
  priority = 1000,
  config = function()
    require('moonlight').set()
  end,
}
