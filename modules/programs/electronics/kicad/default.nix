{ inputs, pkgs, ... }: 
{
  home-manager.sharedModules = [
    ({ pkgs, lib, ... }: { # Add 'lib' here
      home.packages = [ (pkgs.kicad.override { stable = true; }) ];

      gtk = {
        enable = true;
        theme = {
          # Use lib.mkForce to override your global Catppuccin setting
          name = lib.mkForce "Adwaita-dark"; 
          package = lib.mkForce pkgs.gnome-themes-extra;
        };
      };
    })
  ];
}
