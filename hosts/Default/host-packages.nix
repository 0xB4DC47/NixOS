{ pkgs, inputs, ... }:
{
  environment.systemPackages = with pkgs; [
    obsidian
    ludusavi # For game saves
    protonvpn-gui # VPN
    github-desktop
    ripgrep
    pokego # Overlayed
    inputs.nixCats.packages.${stdenv.hostPlatform.system}.nixCats
  ];
}
