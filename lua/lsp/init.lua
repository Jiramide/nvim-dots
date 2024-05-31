return {
  "neovim/nvim-lspconfig",
  dependencies = {
    { "williamboman/mason.nvim", config = true },
    { "williamboman/mason-lspconfig.nvim" },
    { "WhoIsSethDaniel/mason-tool-installer.nvim" },

    { "j-hui/fidget.nvim", opts = {} },
  },

  config = function()
    vim.api.nvim_create_autocmd(
      "LspAttach",
      {
        group = vim.api.nvim_create_augroup("LspMappings", { clear = true }),
        callback = function(event)
          local function map(keys, func, desc)
            vim.keymap.set("n", keys, func, { buffer = event.buf, desc = desc })
          end

          map("gd", vim.lsp.buf.definition, "Goto definitions")
          map("gr", vim.lsp.buf.references, "Goto references")
          map("gI", vim.lsp.buf.implementation, "Goto implementation")
          map("<leader>D", vim.lsp.buf.type_definition, "Goto type definition")
          map("<leader>ds", vim.lsp.buf.document_symbol, "Document symbols")
          map("<leader>ws", vim.lsp.buf.workspace_symbol, "Workspace symbols")
          map("<leader>rn", vim.lsp.buf.rename, "Rename")
          map("<leader>ca", vim.lsp.buf.code_action, "Code action")
          map("K", vim.lsp.buf.hover, "Hover")
          map("gD", vim.lsp.buf.declaration, "Goto declaration")

          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client.server_capabilities.documentHightlightProvider then
            local highlight_augroup = vim.api.nvim_create_augroup("LspDocumentHighlight", { clear = false })

            vim.api.nvim_create_autocmd(
              { "CursorHold", "CursorHoldI" },
              {
                buffer = event.buf,
                group = highlight_augroup,
                callback = vim.lsp.buf.document_highlight,
              }
            )

            vim.api.nvim_create_autocmd(
              { "CursorMoved", "CursorMovedI" },
              {
                buffer = event.buf,
                group = highlight_augroup,
                callback = vim.lsp.buf.clear_references,
              }
            )

            vim.api.nvim_create_autocmd(
              "LspDetach",
              {
                group = vim.api.nvim_create_augroup("LspHighlightDetach", { clear = true }),
                callback = function(event2)
                  vim.lsp.buf.clear_references()
                  vim.api.nvim_clear_autocmds({ group = "LspDocumentHighlight", buffer = event2.buf })
                end,
              }
            )
          end

          if client and client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
            map(
              "<leader>th",
              function()
                vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
              end,
              "Toggle inlay hints"
            )
          end
        end,
      }
    )

    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

    local servers = {
      lua_ls = {
        settings = {
          Lua = {
            completion = {
              callSnippet = "Replace",
            },
          },

          diagnostics = {
            disable = {
              -- "missing-fields",
            },
          },
        },
      },

      tsserver = {

      },
    }

    require("mason").setup()

    local ensure_installed = vim.tbl_keys(servers or {})
    vim.list_extend(
      ensure_installed,
      {
        "stylua",
      }
    )

    --[[
    require("mason-tool-installer").setup(
      {
        ensure_installed = ensure_installed,
      }
    )
    ]]--

    require("mason-lspconfig").setup(
      {
        handlers = {
          function(server_name)
            local server = servers[server_name] or {}

            server.capabilities = vim.tbl_deep_extend(
              "force",
              {},
              capabilities,
              server.capabilities or {}
            )

            require("lspconfig")[server_name].setup(server)
          end,
        },
      }
    )

    for server_name, config in pairs(servers) do
      require("lspconfig")[server_name].setup(config)
    end
  end
}
