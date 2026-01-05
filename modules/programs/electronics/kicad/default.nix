{ inputs, pkgs, ... }: 
{
  home-manager.sharedModules = [
    ({ ... }: {
      home.packages = [
        (pkgs.kicad.override { stable = true; })
      ];
    })
  ];
}
