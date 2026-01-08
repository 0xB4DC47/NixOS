{ config, pkgs, inputs, ... }:

{
  # 1. Enable unfree packages for IDA Free
  nixpkgs.config.allowUnfree = true;

  imports = [
    # Assuming you have home-manager input from a flake
    inputs.home-manager.nixosModules.home-manager
  ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    
    # 2. Define the shared module
    sharedModules = [
      {
        home.packages = [ 
          pkgs.ida-free 
        ];
        
        # Optional: Add a desktop shortcut or alias
        home.shellAliases = {
          ida = "ida-free";
        };
      }
    ];
  };
}
