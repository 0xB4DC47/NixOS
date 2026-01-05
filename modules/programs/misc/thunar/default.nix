{ pkgs, ... }:
{
  programs.thunar = {
    enable = true;
    plugins = with pkgs; [
      xfce.thunar-archive-plugin # Archive management
      xfce.thunar-volman # Volume management (automount removable devices)
      xfce.thunar-media-tags-plugin # Tagging & renaming feature for media files
    ];
  };
  # Archive manager
  environment.systemPackages = with pkgs; [ file-roller ];
}
