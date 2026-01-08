{ pkgs, ... }:

{
  home-manager.sharedModules = [
    ({ config, pkgs, lib, ... }:
    let
      # Use the base package to get versioning
      ghidra_base = pkgs.ghidra-bin;
      
      # Manually construct the folder name. 
      # Ghidra's default folder is: ghidra_<version>_PUBLIC
      ghidra_dir = ".config/ghidra/ghidra_${ghidra_base.version}_PUBLIC";

      # The version with extensions
      ghidra_final = pkgs.ghidra.withExtensions (exts: [
          exts.findcrypt
          exts.ghidra-firmware-utils
          #exts.ghidraninja-ghidra-scripts # skipping this extension for now because of long build times 
          exts.ret-sync
          exts.gnudisassembler
          exts.kaiju
      ]);
    in
    {
      home.packages = [ ghidra_final ];

      home.file."${ghidra_dir}/preferences".text = ''
        USER_AGREEMENT=ACCEPT
        G_FILE_CHOOSER.ShowDotFiles=true
        SHOW_TIPS=false
        GhidraShowWhatsNew=false
        LastNewProjectDirectory=${config.home.homeDirectory}/Documents/ghidra_projects
      '';

      home.activation.createGhidraProjectDir = config.lib.dag.entryAfter ["writeBoundary"] ''
        $DRY_RUN_CMD mkdir -p $VERBOSE_ARG $HOME/Documents/ghidra_projects
      '';
    })
  ];
}
