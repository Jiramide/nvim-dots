return {
  {
    "stevearc/conform.nvim",

    event = { "BufWritePre" },
    cmd = { "ConformInfo" },

    config = function()
      require("conform").setup({
        formatters_by_ft = {
          go = { "gofumpt", "gofmt", stop_after_first = true },
          haskell = { "fourmolu", "ormolu", stop_after_first = true },
          javascript = { "prettierd", "prettier", stop_after_first = true },
          javascriptreact = { "prettierd", "prettier", stop_after_first = true },
          json = { "prettierd", "prettier", stop_after_first = true },
          lua = { "stylua", stop_after_first = true },
          nix = { "nixfmt", stop_after_first = true },
          typescript = { "prettierd", "prettier", stop_after_first = true },
          typescriptreact = { "prettierd", "prettier", stop_after_first = true },
          plaintex = { "latexindent", stop_after_first = true },
          tex = { "latexindent", stop_after_first = true },
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
