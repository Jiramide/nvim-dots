if vim.fn.executable("gcc") == 0 then
  -- if there's no C compiler available, then return an empty plugin spec
  return {}
end

return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",

    config = function()
      require("nvim-treesitter.install").prefer_git = true
      require("nvim-treesitter.configs").setup(
        {
          auto_install = true,
          ensure_installed = {
            "c",
            "cpp",
            "go",
            "haskell",
            "html",
            "javascript",
            -- "latex", requires tree-sitter CLI
            "lua",
            "markdown",
            "typescript",
          },

          highlight = {
            enable = true,
            -- Some languages depend on vim's regex highlighting system (such as Ruby) for indent rules.
            -- If you are experiencing weird indenting issues, add the language to
            -- the list of additional_vim_regex_highlighting and disabled languages for indent.
            additional_vim_regex_highlighting = { "ruby" },
          },

          indent = {
            enable = true,
            disable = { "ruby" },
          }
        }
      )
    end,
  }
}
