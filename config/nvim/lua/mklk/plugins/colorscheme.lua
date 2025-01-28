return {
  {
    'sainnhe/gruvbox-material',
    lazy = false,
    priority = 1000, -- make sure to load this before all the other start plugins
    config = function()
      -- Optionally configure and load the colorscheme
      -- directly inside the plugin declaration.
      vim.g.gruvbox_material_background = 'material'
      vim.g.gruvbox_material_foreground = 'mix'
      vim.g.gruvbox_material_enable_italic = true
      vim.g.gruvbox_material_better_performance = 1

      -- load the colorscheme here
      vim.cmd([[colorscheme gruvbox-material]])
    end,
  },
}
