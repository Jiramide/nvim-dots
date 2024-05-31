return {
  {
    "stevearc/oil.nvim",

    config = function()
      require("oil").setup(
        {
          default_file_exporer = true,
          columns = { "icon" },

          keymaps = {
            ["gd"] = {
              desc = "Toggle detailed view",
              callback = function()
                local oil = require("oil")
                local config = require("oil.config")

                if #config.columns == 1 then
                  oil.set_columns({ "icon", "permissions", "size", "mtime" })
                else
                  oil.set_columns({ "icon" })
                end
              end
            },
          },

          view_options = {
            show_hidden = true,

            is_always_hidden = function(name, _)
              return name == ".."
            end,
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
