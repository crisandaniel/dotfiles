return {
  -- =============================================================================
  -- AUTOCOMPLETE: popup cu sugestii în timp ce scrii (LSP + cuvinte din fișier + căi + snippet-uri)
  -- =============================================================================
  {
    "saghen/blink.cmp",
    version = "1.*", -- versiune stabilă, vine cu binarul fuzzy precompilat
    dependencies = { "rafamadriz/friendly-snippets" }, -- snippet-uri gata făcute pentru zeci de limbaje
    event = { "InsertEnter", "CmdlineEnter" },
    opts = {
      -- Enter acceptă, Ctrl+n/p sau săgețile navighează, Tab/Shift+Tab sar între câmpurile snippet-ului
      -- Ctrl+Space deschide manual popup-ul / documentația, Ctrl+e îl închide
      keymap = { preset = "enter" },
      completion = {
        documentation = { auto_show = true, auto_show_delay_ms = 300 }, -- documentația apare lângă sugestie
        ghost_text = { enabled = true }, -- arată sugestia curentă estompat, direct în text
      },
      signature = { enabled = true }, -- arată parametrii funcției în timp ce îi scrii
      sources = {
        default = { "lsp", "path", "snippets", "buffer" },
      },
    },
  },

  -- =============================================================================
  -- LSP: language servere instalate automat prin Mason și pornite nativ (vim.lsp.enable)
  -- =============================================================================
  {
    "mason-org/mason-lspconfig.nvim",
    dependencies = {
      "williamboman/mason.nvim",
      "neovim/nvim-lspconfig", -- configurațiile implicite pentru fiecare server
      "saghen/blink.cmp",
    },
    config = function()
      -- Spune tuturor serverelor ce poate face autocomplete-ul (snippet-uri, documentație etc.)
      vim.lsp.config("*", {
        capabilities = require("blink.cmp").get_lsp_capabilities(),
      })

      -- Lua: recunoaște variabila globală `vim` când editezi configul nvim
      vim.lsp.config("lua_ls", {
        settings = {
          Lua = {
            diagnostics = { globals = { "vim" } },
            workspace = { checkThirdParty = false },
          },
        },
      })

      require("mason-lspconfig").setup({
        -- Se instalează automat la prima pornire. Orice server instalat ulterior cu :Mason pornește singur.
        -- Ruby (ruby_lsp) NU e aici: cere Ruby 3+. După ce ai Ruby 3: :MasonInstall ruby-lsp
        ensure_installed = {
          -- Web / React / Next.js
          "ts_ls", -- JavaScript, TypeScript, JSX, TSX
          "eslint",
          "html",
          "cssls", -- CSS, SCSS, Less
          "tailwindcss", -- pornește doar în proiecte cu Tailwind
          "emmet_language_server", -- div.clasa>ul>li*3 + Enter
          "jsonls",
          -- Backend
          "intelephense", -- PHP / WordPress
          "pyright", -- Python
          "gopls", -- Go
          "lua_ls", -- Lua (configul nvim)
          -- Config / scripting
          "bashls",
          "yamlls",
          "dockerls",
          "docker_compose_language_service",
          "lemminx", -- XML
          "vimls", -- Vimscript
        },
        automatic_enable = true,
      })

      -- Arată erorile direct pe linie (în 0.11+ sunt ascunse implicit)
      vim.diagnostic.config({
        virtual_text = true,
        severity_sort = true,
        float = { border = "rounded" },
      })

      -- Scurtături active doar în fișierele unde rulează un LSP
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(ev)
          local map = function(keys, fn, desc)
            vim.keymap.set("n", keys, fn, { buffer = ev.buf, desc = desc })
          end
          map("gd", vim.lsp.buf.definition, "LSP: Mergi la definiție")
          -- Implicit în nvim 0.12: grr = unde e folosit, gri = implementare, [d / ]d = eroarea anterioară/următoare
          map("K", vim.lsp.buf.hover, "LSP: Documentație")
          map("<leader>rn", vim.lsp.buf.rename, "LSP: Redenumește")
          map("<leader>ca", vim.lsp.buf.code_action, "LSP: Acțiuni de cod")
          map("<leader>e", vim.diagnostic.open_float, "LSP: Arată eroarea")
        end,
      })
    end,
  },
}
