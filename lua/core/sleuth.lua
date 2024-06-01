local function get_spaces_listchars(shift_width)
  return {
    tab = ">>",
    leadmultispace = "▏" .. (" "):rep(math.max(shift_width - 1, 0))
  }
end

local function get_tabs_listchars(shift_width)
  return {
    leadmultispace = "__", -- we need to set leadmultispace as opposed to lead to overwrite the listchars
    tab = "▏ ",
  }
end

local function set_listchars(event)
  local is_global = vim.v.option_type == "global"
  local opts = is_global and vim.opt or vim.opt_local

  local expand_tab = opts.expandtab:get()
  local shift_width = opts.shiftwidth:get()
  local old_listchars = opts.listchars:get()

  local listchars_producer = expand_tab and get_spaces_listchars or get_tabs_listchars

  opts.listchars = vim.tbl_deep_extend(
    "force",
    old_listchars,
    listchars_producer(shift_width)
  )
end

vim.api.nvim_create_autocmd(
  "OptionSet",
  {
    group = vim.api.nvim_create_augroup("ChangeListChars", { clear = true }),
    pattern = { "expandtab", "shiftwidth" },
    callback = set_listchars,
  }
)

return {
  {
    "tpope/vim-sleuth",
  }
}
