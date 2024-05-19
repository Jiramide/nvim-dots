local function get_spaces_listchars(shift_width)
  return {
    tab = ">>",
    leadmultispace = "|" .. (" "):rep(math.max(shift_width - 1, 0))
  }
end

local function get_tabs_listchars()
  return {
    leadmultispace = "__",
    tab = "| ",
  }
end

local function set_listchars(event)
  local option = event.match
  local is_global = vim.v.option_type == "global"

  if option ~= "shiftwidth" and option ~= "expandtab" then
    -- only change listchars if options are relevant
    return
  end

  local opts = is_global and vim.opt or vim.opt_local
  local expand_tab = opts.expandtab:get()
  local shift_width = opts.shiftwidth:get()
  local old_listchars = opts.listchars:get()

  if expand_tab then
    opts.listchars = vim.tbl_deep_extend(
      "force",
      old_listchars,
      get_spaces_listchars(shift_width)
    )
  else
    opts.listchars = vim.tbl_deep_extend(
      "force",
      old_listchars,
      get_tabs_listchars()
    )
  end
end

vim.api.nvim_create_autocmd(
  "OptionSet",
  {
    group = vim.api.nvim_create_augroup("ChangeListChars", { clear = true }),
    callback = set_listchars,
  }
)

return {
  {
    "tpope/vim-sleuth",
  }
}
