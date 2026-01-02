{ inputs, pkgs, ... }: 
let
  # This creates a 'pkgs' set specifically from your stable input
  # using the same architecture as the main system
  pkgs-stable = import inputs.nixpkgs-stable {
    system = pkgs.stdenv.hostPlatform.system;
    config.allowUnfree = true;
  };
in
{
  home-manager.sharedModules = [
    ({ ... }: {
      home.packages = [
        (pkgs-stable.kicad.override { stable = true; })
      ];
    })
  ];
}
