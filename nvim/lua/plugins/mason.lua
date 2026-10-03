
return {
  -- Managerul de unelte externe (aici îl setăm să instaleze 'ripgrep' pentru căutări ultra-rapide în Telescope)
  { 
    'williamboman/mason.nvim', 
    config = function()
      require("mason").setup()
    end
  },
}
