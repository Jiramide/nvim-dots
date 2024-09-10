-- 1 important

-- 2 moving around
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- 3 tags

-- 4 displaying text
vim.opt.scrolloff = 8
-- vim.opt.sidescrolloff = 4
vim.opt.wrap = false
vim.opt.list = true
vim.opt.number = true
vim.opt.relativenumber = true
-- dynamic based off of indenting rules.
-- @see ./lua/core/sleuth.lua
vim.opt.listchars = { trail = "_" }

-- 5 syntax
vim.opt.hlsearch = false
vim.opt.termguicolors = true
vim.opt.cursorline = true
vim.opt.colorcolumn = { 80, 120 }

-- 6 multiple windows
vim.opt.statuscolumn = '%!v:lua.require("statuscolumn").build()'

-- 7 multiple tab pages

-- 8 terminal

-- 9 using the mouse

-- 10 messages and info
vim.opt.showmode = false

-- 11 selecting text

-- 12 editing text
vim.opt.undofile = true

-- 13 tabs and indenting
vim.opt.shiftwidth = 2
vim.opt.smarttab = true
vim.opt.shiftround = true
vim.opt.expandtab = true

-- 14 folding
vim.opt.foldlevelstart = 99
vim.opt.foldtext = ""
vim.opt.foldopen = { "block", "mark", "percent", "quickfix", "search", "tag", "undo" }

-- 15 diff mode

-- 16 mapping

-- 18 the swap file
vim.opt.updatetime = 1000

-- 21 running make and jumping to errors (quickfix)
if vim.fn.executable("rg") == 1 then
  vim.opt.grepprg = "rg --vimgrep --no-heading --smart-case"
  vim.opt.grepformat:append("%f:%l:%c:%m")
end

vim.opt.inccommand = "split"

vim.g.have_nerd_font = true

vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Go to pane below current pane" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Go to pane above current pane" })
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Go to pane to the left of current pane" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Go to pane to the right of current pane" })

vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Go down half a page" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Go up half a page" })

vim.keymap.set("v", ">", ">gv", { desc = "Tabulate current selection forward" })
vim.keymap.set("v", "<", "<gv", { desc = "Tabulate current selection forward" })

vim.keymap.set({ "n", "v" }, "j", "gj", { desc = "Go down one visual line" })
vim.keymap.set({ "n", "v" }, "k", "gk", { desc = "Go up one visual line" })
vim.keymap.set({ "n", "v" }, "0", "g0", { desc = "Go to the beginning of visual line" })
vim.keymap.set({ "n", "v" }, "$", "g$", { desc = "Go to the end of visual line" })

vim.keymap.set("n", "<A-j>", ":m+1<CR>", { desc = "Move line down" })
vim.keymap.set("n", "<A-k>", ":m-2<CR>", { desc = "Move line up" })
vim.keymap.set("v", "<A-j>", ":m '>+1<CR>gv", { desc = "Move selection down" })
vim.keymap.set("v", "<A-k>", ":m '<-2<CR>gv", { desc = "Move selection up" })

-- Execute some shell command and paste the output
-- This has been modified a bit to use /usr/bin/env bash instead of /bin/bash, since
-- bash is not in the /bin directory on NixOS.
-- @see <https://www.reddit.com/r/neovim/comments/1d24sti/execute_random_commands_from_neovim/>
vim.keymap.set("n", "<leader>xp", "yy2o<ESC>kpV:!/usr/bin/env bash<CR>")
vim.keymap.set("v", "<leader>xp", "y'<P'<O<ESC>'>o<ESC>:<C-u>'<,'>!/usr/bin/env bash<CR>")

-- vim.cmd("colorscheme habamax")

-- Make folded lines a bit more obvious
local folded_hl = vim.api.nvim_get_hl(0, { name = "Folded" })
folded_hl.bg = "#342E4F"
vim.api.nvim_set_hl(0, "Folded", folded_hl)

-- Remove background on VertSplit which ruins WinSeparator
local vert_split_hl = vim.api.nvim_get_hl(0, { name = "VertSplit" })
vert_split_hl.bg = nil
vim.api.nvim_set_hl(0, "VertSplit", vert_split_hl)

--[[
local lsp_reference_read_hl = vim.api.nvim_get_hl(0, { name = "LspReferenceRead" })
local lsp_reference_write_hl = vim.api.nvim_get_hl(0, { name = "LspReferenceWrite" })
lsp_reference_read_hl.bg = "#7F9EAE"
lsp_reference_read_hl.fg = "#F0F0F0"
lsp_reference_read_hl.link = nil
lsp_reference_write_hl.bg = "#DEA7C6"
lsp_reference_write_hl.fg = "#F0F0F0"
lsp_reference_write_hl.link = nil
vim.api.nvim_set_hl(0, "LspReferenceRead", lsp_reference_read_hl)
vim.api.nvim_set_hl(0, "LspReferenceWrite", lsp_reference_write_hl)
]]

vim.api.nvim_set_hl(0, "Visual", { bg = "#342E4F" })

local DISABLE_INSERT_LINE_ON_FT = {
  TelescopePrompt = true,
}

vim.api.nvim_create_autocmd({ "InsertEnter", "InsertLeave" }, {
  group = vim.api.nvim_create_augroup("ChangeLineNumber", { clear = true }),
  pattern = "*",
  callback = function(ctx)
    local event = ctx.event
    local filetype = vim.bo[ctx.buf].filetype

    if DISABLE_INSERT_LINE_ON_FT[filetype] then
      return
    end

    -- Enable relative number when leaving insert mode
    vim.wo.relativenumber = event == "InsertLeave"
  end,
})

--[[
local severity_to_hl = {
  [vim.diagnostic.severity.ERROR] = "DiagnosticVirtualTextError",
  [vim.diagnostic.severity.WARN] = "DiagnosticVirtualTextWarn",
  [vim.diagnostic.severity.INFO] = "DiagnosticVirtualTextInfo",
  [vim.diagnostic.severity.HINT] = "DiagnosticVirtualTextHint",
}

local function get_diagnostic_hl(severity)
  return severity_to_hl[severity] or "Normal"
end

vim.api.nvim_create_autocmd({ "DiagnosticChanged", "CursorMoved" }, {
  callback = function(ctx)
    local bufnr = ctx.buf
    local cursor = vim.api.nvim_win_get_cursor(0)

    vim.api.nvim_buf_clear_namespace(bufnr, vim.api.nvim_create_namespace("VirtualDiagnostics"), 0, -1)

    -- Both are 0-indexed
    local row = cursor[1] - 1
    local col = cursor[2]

    local line_diagnostics = vim.diagnostic.get(bufnr, {
      lnum = row,
    })

    for _, diagnostic in ipairs(line_diagnostics) do
      local diag_start_col = diagnostic.col
      local diag_end_col = diagnostic.end_col
      local is_in_diagnostic = diagnostic.lnum < row
        or diagnostic.end_lnum > row
        or (diag_start_col <= col and col <= diag_end_col)

      if is_in_diagnostic then
        local ns = vim.api.nvim_create_namespace("VirtualDiagnostics")
        local diag_text = diagnostic.message
        local win_width = vim.api.nvim_win_get_width(0)

        local diag_lines = {
          {
            { string.rep("─", diag_start_col), get_diagnostic_hl(diagnostic.severity) },
            { "🮧", get_diagnostic_hl(diagnostic.severity) },
            { string.rep("─", win_width - diag_start_col - 1), get_diagnostic_hl(diagnostic.severity) },
          },
        }

        for line in diag_text:gmatch("[^\r\n]+") do
          table.insert(diag_lines, {
            { string.rep(" ", diag_start_col), "Normal" },
            { line, get_diagnostic_hl(diagnostic.severity) },
          })
        end

        table.insert(diag_lines, {
          { string.rep("─", win_width), get_diagnostic_hl(diagnostic.severity) },
        })

        vim.api.nvim_buf_set_extmark(bufnr, ns, row, diag_start_col, {
          virt_lines = diag_lines,
        })

        break
      end
    end
  end,
})
    ]]

require("init")
