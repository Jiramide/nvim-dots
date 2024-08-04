return {
  "neovim/nvim-lspconfig",
  dependencies = {
    { "j-hui/fidget.nvim", opts = {} },
  },

  config = function()
    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("LspMappings", { clear = true }),
      callback = function(event)
        local function map(keys, func, desc)
          vim.keymap.set("n", keys, func, { buffer = event.buf, desc = desc })
        end

        local builtin = require("telescope.builtin")

        map("gd", builtin.lsp_definitions, "Goto definitions")
        map("gr", builtin.lsp_references, "Goto references")
        map("gI", builtin.lsp_implementations, "Goto implementation")
        map("<leader>D", builtin.lsp_type_definitions, "Goto type definition")
        map("<leader>ds", builtin.lsp_document_symbols, "Document symbols")
        map("<leader>ws", builtin.lsp_workspace_symbols, "Workspace symbols")
        map("<leader>rn", vim.lsp.buf.rename, "Rename")
        map("<leader>ca", vim.lsp.buf.code_action, "Code action")
        map("<leader>oc", builtin.lsp_outgoing_calls, "Outgoing calls")
        map("<leader>ic", builtin.lsp_incoming_calls, "Incoming calls")

        map("K", vim.lsp.buf.hover, "Hover")
        map("gD", vim.lsp.buf.declaration, "Goto declaration")
        map("[d", vim.diagnostic.goto_prev, "Goto previous diagnostic")
        map("]d", vim.diagnostic.goto_next, "Goto previous diagnostic")

        local client = vim.lsp.get_client_by_id(event.data.client_id)
        if client and client.server_capabilities.documentHightlightProvider then
          local highlight_augroup = vim.api.nvim_create_augroup("LspDocumentHighlight", { clear = false })

          vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
            buffer = event.buf,
            group = highlight_augroup,
            callback = vim.lsp.buf.document_highlight,
          })

          vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
            buffer = event.buf,
            group = highlight_augroup,
            callback = vim.lsp.buf.clear_references,
          })

          vim.api.nvim_create_autocmd("LspDetach", {
            group = vim.api.nvim_create_augroup("LspHighlightDetach", { clear = true }),
            callback = function(event2)
              vim.lsp.buf.clear_references()
              vim.api.nvim_clear_autocmds({ group = "LspDocumentHighlight", buffer = event2.buf })
            end,
          })
        end

        if client and client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
          map("<leader>th", function()
            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
          end, "Toggle inlay hints")
        end
      end,
    })

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

      tsserver = {},

      rust_analyzer = {},

      gopls = {
        gofumpt = true,
        codelenses = {
          gc_details = false,
          generate = true,
          regenerate_cgo = true,
          run_govulncheck = true,
          test = true,
          tidy = true,
          upgrade_dependency = true,
          vendor = true,
        },
        hints = {
          assignVariableTypes = true,
          compositeLiteralFields = true,
          compositeLiteralTypes = true,
          constantValues = true,
          functionTypeParameters = true,
          parameterNames = true,
          rangeVariableTypes = true,
        },
        analyses = {
          fieldalignment = true,
          nilness = true,
          unusedparams = true,
          unusedwrite = true,
          useany = true,
        },
        usePlaceholders = true,
        completeUnimported = true,
        staticcheck = true,
        directoryFilters = { "-.git", "-.vscode", "-.idea", "-.vscode-test", "-node_modules" },
        semanticTokens = true,
      },

      clangd = {},
    }

    for server_name, config in pairs(servers) do
      require("lspconfig")[server_name].setup(config)
    end
  end,
}
