{ pkgs, ... }:
{
  home-manager.sharedModules = [
    ({ ... }: {
      home.packages = [
        pkgs.qbittorrent
      ];
      xdg.configFile."qBittorrent/qBittorrent.conf".text = ''
        [BitTorrent]
        Session\Interface=mullvad
        Session\InterfaceName=mullvad
      '';
    })
  ];
}
