return {
  {
    "dgox16/oldworld.nvim",
    lazy = false,
    priority = 1000,

    config = function()
      vim.cmd([[colorscheme oldworld]])
      vim.api.nvim_set_hl(0, "StatusLineNC", { link = "StatusLine" })
    end,
  },
}
