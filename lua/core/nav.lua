return {
  --[[
  {
    "mawkler/refjump.nvim",
    dependencies = { "mawkler/demicolon.nvim" },
    keys = { "]r", "[r" },

    opts = {},
  },

  {
    "mawkler/demicolon.nvim",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-treesitter/nvim-treesitter-textobjects",
    },
    keys = { ";", ",", "t", "f", "T", "F", "]", "[", "]d", "[d" },

    opts = {},
  },
  --]]
}
