{ pkgs, ... }:
{
  home-manager.sharedModules = [
    ({ ... }: {
      home.packages = [
        pkgs.qbittorrent
      ];
      xdg.configFile."qBittorrent/qBittorrent.conf".text = ''
        [BitTorrent]
        Session\Interface=wg0-mullvad
        Session\InterfaceName=wg0-mullvad
      '';
    })
  ];
}
