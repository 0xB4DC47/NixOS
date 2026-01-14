{
  username = "phil"; # auto-set with install.sh, live-install.sh, and rebuild scripts.

  # Desktop Environment
  desktop = "hyprland"; # hyprland, i3, gnome, plasma6

  # Theme & Appearance
  waybarTheme = "minimal"; # stylish, minimal
  sddmTheme = "hyprland_kath"; # astronaut, black_hole, purple_leaves, jake_the_dog, hyprland_kath
  defaultWallpaper = "train-sideview.webp"; # Change with SUPER + SHIFT + W
  hyprlockWallpaper = "train-sideview.webp";

  # Default Applications
  terminal = "kitty"; # kitty, alacritty
  editor = "nixvim"; # nixvim, vscode, helix, doom-emacs, nvchad, neovim
  browser = "zen"; # zen, firefox, floorp
  tuiFileManager = "yazi"; # yazi, lf
  shell = "zsh"; # zsh, bash
  games = true; # Enable/Disable gaming module

  # Hardware
  hostname = "nixos-desktop";
  videoDriver = "nvidia"; # nvidia, amdgpu, intel

  # Localization
  timezone = "America/New_York";
  locale = "en_US.UTF-8";
  clock24h = false;
  kbdLayout = "us";
  kbdVariant = "";
  consoleKeymap = "us";
}
