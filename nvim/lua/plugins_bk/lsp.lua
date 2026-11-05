return {
  -- DISABLED: autocomplete (blink.cmp) and LSP. To re-enable, delete the "--[[" and "--]]" lines.
  --[[
  -- =============================================================================
  -- AUTOCOMPLETE: suggestions popup while typing (LSP + words in file + paths + snippets)
  -- =============================================================================
  {
    "saghen/blink.cmp",
    version = "1.*", -- stable release, ships the prebuilt fuzzy matcher binary
    dependencies = { "rafamadriz/friendly-snippets" }, -- ready-made snippets for dozens of languages
    event = { "InsertEnter", "CmdlineEnter" },
    opts = {
      -- Enter accepts, Ctrl+n/p or arrows navigate, Tab/Shift+Tab jump between snippet fields
      -- Ctrl+Space opens the popup / docs manually, Ctrl+e closes it
      keymap = { preset = "enter" },
      completion = {
        documentation = { auto_show = true, auto_show_delay_ms = 300 }, -- docs appear next to the suggestion
        ghost_text = { enabled = true }, -- show the current suggestion dimmed, inline
      },
      signature = { enabled = true }, -- show function parameters while typing them
      sources = {
        default = { "lsp", "path", "snippets", "buffer" },
      },
    },
  },

  -- =============================================================================
  -- LSP: language servers installed automatically via Mason and started natively (vim.lsp.enable)
  -- =============================================================================
  {
    "mason-org/mason-lspconfig.nvim",
    dependencies = {
      "williamboman/mason.nvim",
      "neovim/nvim-lspconfig", -- default configs for each server
      "saghen/blink.cmp",
    },
    config = function()
      -- Tell all servers what the completion engine supports (snippets, docs etc.)
      vim.lsp.config("*", {
        capabilities = require("blink.cmp").get_lsp_capabilities(),
      })

      -- Lua: recognize the global `vim` when editing the nvim config
      vim.lsp.config("lua_ls", {
        settings = {
          Lua = {
            diagnostics = { globals = { "vim" } },
            workspace = { checkThirdParty = false },
          },
        },
      })

      require("mason-lspconfig").setup({
        -- Installed automatically on first start. Any server installed later with :Mason starts on its own.
        -- Ruby (ruby_lsp) is NOT here: it needs Ruby 3+. Once you have Ruby 3: :MasonInstall ruby-lsp
        ensure_installed = {
          -- Web / React / Next.js
          "ts_ls", -- JavaScript, TypeScript, JSX, TSX
          "eslint",
          "html",
          "cssls", -- CSS, SCSS, Less
          "tailwindcss", -- only starts in Tailwind projects
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

      -- Show errors inline (hidden by default in 0.11+)
      vim.diagnostic.config({
        virtual_text = true,
        severity_sort = true,
        float = { border = "rounded" },
      })

      -- Shortcuts active only in files with a running LSP
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(ev)
          local map = function(keys, fn, desc)
            vim.keymap.set("n", keys, fn, { buffer = ev.buf, desc = desc })
          end
          map("gd", vim.lsp.buf.definition, "LSP: Go to definition")
          -- Built into nvim 0.12: grr = references, gri = implementation, [d / ]d = previous/next diagnostic
          map("K", vim.lsp.buf.hover, "LSP: Documentation")
          map("<leader>rn", vim.lsp.buf.rename, "LSP: Rename")
          map("<leader>ca", vim.lsp.buf.code_action, "LSP: Code actions")
          map("<leader>e", vim.diagnostic.open_float, "LSP: Show diagnostic")
        end,
      })
    end,
  },
  --]]
}
