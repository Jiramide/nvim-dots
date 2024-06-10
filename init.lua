-- 1 important

-- 2 moving around
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- 3 tags

-- 4 displaying text
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 4
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

-- 7 multiple tab pages

-- 8 terminal

-- 9 using the mouse

-- 10 messages and info
vim.opt.showmode = false

-- 11 selecting text

-- 12 editing text

-- 13 tabs and indenting
vim.opt.shiftwidth = 2
vim.opt.smarttab = true
vim.opt.shiftround = true
vim.opt.expandtab = true

-- 14 folding

-- 15 diff mode

-- 16 mapping

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
vim.keymap.set({ "n", "v" }, "$", "g$", { desc = "Go to the end of visual line"})

-- Execute some shell command and paste the output
-- This has been modified a bit to use /usr/bin/env bash instead of /bin/bash, since
-- bash is not in the /bin directory on NixOS.
-- @see <https://www.reddit.com/r/neovim/comments/1d24sti/execute_random_commands_from_neovim/>
vim.keymap.set("n", "<leader>xp", "yy2o<ESC>kpV:!/usr/bin/env bash<CR>")
vim.keymap.set("v", "<leader>xp", "y'<P'<O<ESC>'>o<ESC>:<C-u>'<,'>!/usr/bin/env bash<CR>")

vim.cmd("colorscheme habamax")

-- Remove background on VertSplit which ruins WinSeparator
local vert_split_hl = vim.api.nvim_get_hl(0, { name = "VertSplit" })
vert_split_hl.bg = nil
vim.api.nvim_set_hl(0, "VertSplit", vert_split_hl)

local DISABLE_INSERT_LINE_ON_FT = {
  TelescopePrompt = true,
}

vim.api.nvim_create_autocmd(
  { "InsertEnter", "InsertLeave" },
  {
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
  }
)

require("init")
