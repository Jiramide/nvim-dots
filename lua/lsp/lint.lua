return {
  {
    "mfussenegger/nvim-lint",
    lazy = true,
    event = { "BufReadPre", "BufNewFile" },

    config = function()
      local lint = require("lint")

      lint.linters_by_ft = {
        go = { "golangcilint" },
      }

      vim.api.nvim_create_autocmd(
        { "BufEnter", "BufWritePost", "InsertLeave" },
        {
          group = vim.api.nvim_create_augroup("Lint", { clear = true }),
          callback = function()
            lint.try_lint()
          end,
        }
      )
    end
  }
}
