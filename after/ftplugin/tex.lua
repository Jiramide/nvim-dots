vim.opt_local.makeprg = "max_print_line=10000 pdflatex -shell-escape -file-line-error -interaction nonstopmode -output-directory %:h:S %:S"
vim.opt_local.errorformat = { "%-P**%f", "%-P**\"%f\"", "%E! LaTeX %trror: %m", "%E%f:%l: %m", "%E! %m", "%Z<argument> %m", "%Cl.%l %m", "%-G%.%#" }
vim.opt_local.textwidth = 120
