local function fold_column()
  local line = vim.v.lnum

  local fold_level = vim.fn.foldlevel(line)
  local previous_fold_level = line > 1 and vim.fn.foldlevel(line - 1) or -math.huge
  local next_fold_level = line < vim.fn.line("$") and vim.fn.foldlevel(line + 1) or -math.huge
  local is_closed = vim.fn.foldclosed(line) ~= -1

  if fold_level == 0 then
    return " "
  end

  if is_closed then
    return "▶"
  end

  if fold_level > previous_fold_level then
    return "▽"
  end

  if fold_level > next_fold_level then
    return "╰"
  end

  return "│"
end

local function line_number()
  local line = vim.v.lnum
  local relative_line = vim.v.relnum

  if relative_line == 0 then
    return line
  end

  return "%=%{" .. relative_line .. "}"
end

return function()
  return table.concat({
    fold_column(),
    " ",
    line_number(),
    " ",
  })
end
