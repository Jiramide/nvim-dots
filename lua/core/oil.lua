return {
  {
    "stevearc/oil.nvim",

    config = function()
      require("oil").setup(
        {
          default_file_exporer = true,
          columns = { "icon" },

          view_options = {
            show_hidden = true,
          },
        }
      )

      vim.keymap.set("n", "-", require("oil").open, { desc = "Open parent directory" })
    end,

    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
  }
}
