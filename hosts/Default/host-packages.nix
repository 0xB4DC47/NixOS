{ pkgs, inputs, ... }:
{
  environment.systemPackages = with pkgs; [
    obsidian
    ludusavi # For game saves
    protonvpn-gui # VPN
    github-desktop
    ripgrep
    pokego # Overlayed
    #inputs.nixCats.packages.${stdenv.hostPlatform.system}.nixCats
    inputs.neovim.packages.${stdenv.hostPlatform.system}.neovim
    gnome-calculator
    inputs.llm-agents.packages.${stdenv.hostPlatform.system}.claude-code
    audacity
    signal-desktop
    libreoffice-qt-fresh
    gnome-text-editor
    ani-cli
    android-tools
  ];
}
