{ config, pkgs, lib, ... }:

let
  # Choose your package: 'ghidra' (from source) or 'ghidra-bin' (pre-compiled)
  # Note: Extensions usually require the 'ghidra' package (built from source).
  ghidra_pkg = pkgs.ghidra-bin;

  # Ghidra stores config in ~/.config/ghidra/ghidra_<version>_PUBLIC
  # This dynamic prefix helps keep the config pointing to the right spot.
  ghidra_dir = ".config/ghidra/${ghidra_pkg.distroPrefix}";
in
{
  home.packages = [
    ghidra_pkg
  ];

  # Declarative Preferences
  # Note: Since these files are in the Nix store (read-only), 
  # Ghidra won't be able to save new settings changed in the GUI.
  home.file."${ghidra_dir}/preferences".text = ''
    USER_AGREEMENT=ACCEPT
    G_FILE_CHOOSER.ShowDotFiles=true
    SHOW_TIPS=false
    GhidraShowWhatsNew=false
    LastNewProjectDirectory=${config.home.homeDirectory}/Documents/ghidra_projects
  '';

  # Ensure the project directory exists
  home.activation = {
    createGhidraProjectDir = lib.hm.dag.entryAfter ["writeBoundary"] ''
      mkdir -p $HOME/Documents/ghidra_projects
    '';
  };
}
