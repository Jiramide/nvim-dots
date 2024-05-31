return {
  {
    "nvim-treesitter/nvim-treesitter-context",
    dependencies = { "nvim-treesitter/nvim-treesitter" },

    config = function()
      require("treesitter-context").setup(
        {
          enable = true,
          max_lines = 0,
        }
      )

      vim.keymap.set("n", "[c", function()
        require("treesitter-context").go_to_context(vim.v.count1)
      end)
    end,
  }
}
