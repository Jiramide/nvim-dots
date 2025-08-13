local statuscolumn = {}

local function foldexpr(line)
  return tostring(vim.treesitter.foldexpr(line))
end

local function is_in_fold(line)
  return vim.fn.foldlevel(line) ~= 0
end

local function is_fold_start(line)
  if vim.v.virtnum ~= 0 then
    return false
  end

  return foldexpr(line):sub(1, 1) == ">" and foldexpr(line + 1) ~= vim.treesitter.foldexpr(line)
end

local function is_fold_end(line)
  if vim.v.virtnum ~= 0 then
    return false
  end

  local next = foldexpr(line + 1)
  local curr = foldexpr(line)

  if curr == "=" then
    return false
  end

  if next == "=" then
    return false
  end

  if next:sub(1, 1) == ">" then
    return tonumber(next:sub(2)) <= tonumber(curr:sub(1, 1) == ">" and curr:sub(2) or curr)
  end

  return tonumber(curr) > tonumber(next)
end

local function is_fold_closed(line)
  return vim.fn.foldclosed(line) ~= -1
end

--[[
local fold_colours = {
  "#CAD2C5",
  "#84A98C",
  "#52796F",
  -- "#354F52",
  -- "#2F3E46",
}
]]

--[[
local fold_colours = {
  "#0054db",
  "#FF0896",
  "#FF5F5A",
  "#FF842B",
  "#FAA700",
}
]]

--[[
local fold_colours = {
  "#0249c4",
  "#e50882",
  "#e55951",
  "#e57a27",
  "#e19a00",
}
]]

--[[
local fold_colours = {
  "#4d646d",
  "#6b7e9f",
  "#d184af",
  "#ffac6e",
  "#ffe1a5",
}
]]

local fold_colours = {
  "#7f9eae",
  "#dea7c6",
  -- "#ffb2af",
  "#ffc397",
  "#ffe9be",
}

--[[
local fold_colours = {
  "#00202e",
  "#003f5c",
  "#2c4875",
  "#8a508f",
  "#bc5090",
  "#ff6361",
  "#ff8531",
  "#ffa600",
  "#ffd380",
}
]]

--[[
local fold_colours = {
  "#03328b",
  "#a4065a",
  "#a54138",
  "#a45a1b",
  "#a17000",
}
]]

--[[
local fold_colours = {
  "#AABA78",
  -- "#CCD5AE",
  -- "#E9EDC9",
  "#FEFAE0",
  -- "#FAEDCD",
  "#D4A373",
}
]]

for index, colour in pairs(fold_colours) do
  vim.api.nvim_set_hl(0, "FoldLevel" .. index, {
    fg = colour,
  })
end

local function fold_column()
  local line = vim.v.lnum
  local fold_level = (vim.fn.foldlevel(line) - 1) % #fold_colours + 1

  if not is_in_fold(line) then
    return " "
  end

  if is_fold_closed(line) then
    return "%#FoldLevel" .. tostring(fold_level) .. "#▶"
  end

  if is_fold_start(line) then
    return "%#FoldLevel" .. tostring(fold_level) .. "#▽"
  end

  if is_fold_end(line) then
    return "%#FoldLevel" .. tostring(fold_level) .. "#╰"
  end

  return "%#FoldLevel" .. tostring(fold_level) .. "#│"
end

local function cmd_mode_line_number()
  local render_line = vim.v.lnum
  local cursor_line = vim.fn.line(".")

  return "%=%{" .. tostring(render_line - cursor_line) .. "}"
end

local function insert_mode_line_number()
  return tostring(vim.v.lnum)
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
  local hi = vim.v.relnum == 0 and "CursorLineNr" or "LineNr"

  if vim.v.virtnum ~= 0 then
    return ""
  end

  if mode == "i" then
    return "%#" .. hi .. "#" .. insert_mode_line_number()
  else
    return "%#" .. hi .. "#" .. normal_mode_line_number()
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
    " ",
    "%s",
    fold_column(),
    " ",
    line_number(),
    " ",
  })
end

-- stylua: ignore start
do

  do

    do

      do

        do

          do

            do

              do

                do

                  do

                  end

                end

              end

            end

          end

        end

      end

    end

  end

end
-- stylua: ignore end

return statuscolumn
