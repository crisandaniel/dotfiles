
return {
  {
    'nvim-treesitter/nvim-treesitter',
    lazy = false,
    build = ':TSUpdate',
    config = function ()
    local ts = require("nvim-treesitter")
      ts.setup({
        highlight = { enable = true },
        indent = { enable = true },
      })
      -- Automatically download parsers for these languages
      ts.install({ 
        "c", "lua", "vim", "vimdoc", "query", "markdown", "markdown_inline", 
        "javascript", "html", "php", "css", "scss",
        "typescript", "tsx", "json", "ruby", "xml", "bash", "yaml",
        "python", "go", "dockerfile"
      })
    end
  },
}
