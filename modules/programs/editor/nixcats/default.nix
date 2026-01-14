{ inputs, pkgs, ... }:
{
  imports = [ inputs.nixCats.homeModule ];

  config.nixCats = {
    enable = true;
    packageNames = [ "nvim" ];
    # Points to the directory we are about to create
    luaPath = "${./lua}"; 

    packageDefinitions = {
      nvim = { pkgs, ... }: {
        settings = {
          wrapRc = true;
          configDirName = "nvim";
          aliases = [ "vim" "nv" "vi" ];
          nixCats_lazy_wrapper = true; 
        };
        categories = {
          general = true;
          git = true;
          lsp = true;
          lazyVim = true;
        };
      };
    };

    categoryDefinitions = {
      lspsAndRuntimeDeps = { pkgs, ... }: {
        general = with pkgs; [ ripgrep fd xclip wl-copy ];
        git = with pkgs; [ git lazygit ];
        lsp = with pkgs; [ 
          lua-language-server 
          nil
          pyright
          nodePackages.typescript-language-server
          zls
          zig
          rust-analyzer
          rustc
          cargo
          clang-tools
          gcc
          gnumake
        ];
      };

      startupPlugins = { pkgs, ... }: {
        general = with pkgs.vimPlugins; [ 
          lazy-nvim 
        ];
        lazyVim = with pkgs.vimPlugins; [ 
          LazyVim 
          # Essential LazyVim dependencies often found in nixpkgs
          bufferline-nvim
          lualine-nvim
          nvim-treesitter.withAllGrammars
          telescope-nvim
          which-key-nvim
          rustaceanvim
        ];
      };
    };
  };
}
