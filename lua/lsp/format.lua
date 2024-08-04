return {
  {
    "stevearc/conform.nvim",

    event = { "BufWritePre" },
    cmd = { "ConformInfo" },

    config = function()
      require("conform").setup({
        formatters_by_ft = {
          lua = { "stylua" },
          go = { { "gofumpt", "gofmt" } },
          javascript = { { "prettierd", "prettier" } },
          typescript = { { "prettierd", "prettier" } },
          javascriptreact = { { "prettierd", "prettier" } },
          typescriptreact = { { "prettierd", "prettier" } },
        },

        format_on_save = {
          timeout_ms = 500,
          lsp_format = "fallback",
        },
      })

      vim.o.formatexpr = 'v:lua.require("conform").formatexpr()'
    end,
  },
}
