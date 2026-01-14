return {
  -- Disable Mason entirely
  { "williamboman/mason.nvim", enabled = false },
  { "williamboman/mason-lspconfig.nvim", enabled = false },

  -- Configure Treesitter to use Nix-provided parsers
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {}, -- Nix handles this via withAllGrammars
      auto_install = false,
    },
  },

  -- Tell LazyVim which LSPs you have provided via Nix
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        nil_ls = {},     -- Nix LSP
        pyright = {},    -- Python
        lua_ls = {},     -- Lua
        tsserver = {},   -- JS/TS
      },
    },
  },
}
