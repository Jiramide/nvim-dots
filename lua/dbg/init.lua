local dbg_mode

return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "debugloop/layers.nvim",
    },

    config = function()
      local dap = require("dap")

      dap.adapters.gdb = {
        type = "executable",
        command = "gdb",
        args = { "-i", "dap" },
      }

      dap.configurations.c = {
        {
          name = "Launch",
          type = "gdb",
          request = "launch",
          program = function()
            return vim.fn.input("Executable: ", vim.fn.getcwd() .. "/", "file")
          end,
          cwd = "${workspaceFolder}",
          stopAtBeginningOfMainSubprogram = false,
        },
      }
      dap.configurations.cpp = dap.configurations.c

      dbg_mode = Layers.mode.new()
      dbg_mode:auto_show_help()
      dbg_mode:keymaps({
        n = {
          {
            "s",
            dap.step_over,
            { desc = "Step over" },
          },
          {
            "i",
            dap.step_into,
            { desc = "Step into" },
          },
          {
            "S",
            dap.step_out,
            { desc = "Step out" },
          },
          {
            "b",
            dap.toggle_breakpoint,
            { desc = "Toggle breakpoint" },
          },
          {
            "c",
            dap.continue,
            { desc = "Continue" },
          },
          {
            "<esc>",
            function()
              dbg_mode:deactivate()
            end,
            { desc = "Exit" },
          },
        },
      })

      vim.keymap.set("n", "<leader>dbg", function()
        dbg_mode:activate()
      end, { desc = "Debug mode" })
    end,
  },

  {
    "rcarriga/nvim-dap-ui",
    dependencies = {
      "mfussenegger/nvim-dap",
      "nvim-neotest/nvim-nio",
    },

    config = function()
      local dap = require("dap")
      local dapui = require("dapui")

      dapui.setup()

      dap.listeners.before.attach.dapui_config = function()
        dapui.open()
      end

      dap.listeners.before.launch.dapui_config = function()
        dapui.open()
      end

      dap.listeners.before.event_terminated.dapui_config = function()
        dapui.close()
      end

      dap.listeners.before.event_exited.dapui_config = function()
        dapui.open()
      end

      dbg_mode:keymaps({
        n = {
          {
            "o",
            dapui.open,
            { desc = "Open ui" },
          },
          {
            "x",
            dapui.close,
            { desc = "Close ui" },
          },
        },
      })
    end,
  },

  {
    "theHamsta/nvim-dap-virtual-text",
    dependencies = {
      "mfussenegger/nvim-dap",
      "nvim-treesitter/nvim-treesitter",
    },

    opts = {},
  },
}
