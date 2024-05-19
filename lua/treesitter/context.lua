return {
  {
    "nvim-treesitter/nvim-treesitter-context",
    deps = { "nvim-treesitter/nvim-treesitter" },

    config = function()
      require("treesitter-context").setup(
        {
          enable = true,
          max_lines = 2,
        }
      )
    end,
  }
}
