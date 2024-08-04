local statuscolumn = {}

local function is_in_fold(line)
  return vim.fn.foldlevel(line) ~= 0
end

local function is_fold_start(line)
  local previous_fold_level = line > 1 and vim.fn.foldlevel(line - 1) or -math.huge
  return vim.fn.foldlevel(line) > previous_fold_level
end

local function is_fold_end(line)
  local next_fold_level = line < vim.fn.line("$") and vim.fn.foldlevel(line + 1) or -math.huge
  return vim.fn.foldlevel(line) > next_fold_level
end

local function is_fold_closed(line)
  return vim.fn.foldclosed(line) ~= -1
end

local function fold_column()
  local line = vim.v.lnum

  if not is_in_fold(line) then
    return " "
  end

  if is_fold_closed(line) then
    return "▶"
  end

  if is_fold_start(line) then
    return "▽"
  end

  if is_fold_end(line) then
    return "╰"
  end

  return "│"
end

local function cmd_mode_line_number()
  local render_line = vim.v.lnum
  local cursor_line = vim.fn.line(".")

  return "%=%{" .. tostring(render_line - cursor_line) .. "}"
end

local function insert_mode_line_number()
  return vim.v.lnum
end

local function normal_mode_line_number()
  local line = vim.v.lnum
  local relative_line = vim.v.relnum

  if relative_line == 0 then
    return line
  end

  return "%=%{" .. relative_line .. "}"
end

local function line_number()
  local mode = vim.api.nvim_get_mode().mode

  if mode == "i" then
    return insert_mode_line_number()
  else
    return normal_mode_line_number()
  end
end

function _G.fold_click_handler()
  local line = vim.fn.getmousepos().line

  if not is_fold_start(line) then
    return
  end

  local cmd = table.concat({
    line,
    "fold",
    is_fold_closed(line) and "open" or "close",
  })

  vim.cmd(cmd)
end

function statuscolumn.build()
  return table.concat({
    "%@v:lua.fold_click_handler@",
    fold_column(),
    " ",
    line_number(),
    " ",
  })
end

return statuscolumn
