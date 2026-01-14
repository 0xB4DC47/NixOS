-- Initialize the nixCats bridge
-- This allows lazy.nvim to see plugins in the Nix store
require('nixCats').setup({})

-- Setup lazy.nvim with LazyVim
require("lazy").setup({
  spec = {
    -- 1. Import the core LazyVim framework
    { "LazyVim/LazyVim", import = "lazyvim.plugins" },
    -- 2. Import your own custom overrides/plugins
    { import = "plugins" },
  },
  defaults = {
    lazy = false,
    version = false,
  },
  -- IMPORTANT: NixOS is read-only. We must tell Lazy NOT to install things.
  install = { missing = false }, 
  checker = { enabled = false }, 
})
