
return {
  -- External tools manager (language servers, linters, formatters)
  { 
    'williamboman/mason.nvim', 
    config = function()
      require("mason").setup()
    end
  },
}
