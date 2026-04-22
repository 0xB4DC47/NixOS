{ lib, pkgs, ... }:
let
  vars = import ./variables.nix;
in
{
  imports = [
    ./hardware-configuration.nix
    ./host-packages.nix

    # Core Modules (Don't change unless you know what you're doing)
    ../../modules/scripts
    ../../modules/core/boot.nix
    ../../modules/core/bash.nix
    ../../modules/core/zsh.nix
    ../../modules/core/starship.nix
    ../../modules/core/fonts.nix
    ../../modules/core/hardware.nix
    ../../modules/core/network.nix
    ../../modules/core/dns.nix
    ../../modules/core/nh.nix
    ../../modules/core/packages.nix
    ../../modules/core/printing.nix
    ../../modules/core/sddm.nix
    ../../modules/core/security.nix
    ../../modules/core/services.nix
    ../../modules/core/syncthing.nix
    ../../modules/core/system.nix
    ../../modules/core/users.nix
    ../../modules/core/flatpak.nix
    ../../modules/core/virtualisation.nix
    # ../../modules/core/dlna.nix

    # Optional
    ../../modules/hardware/video/${vars.videoDriver}.nix # Enable gpu drivers defined in variables.nix
    ../../modules/desktop/${vars.desktop} # Set window manager defined in variables.nix
    ../../modules/programs/browser/${vars.browser} # Set browser defined in variables.nix
    ../../modules/programs/browser/firefox
    ../../modules/programs/browser/brave
    ../../modules/programs/terminal/${vars.terminal} # Set terminal defined in variables.nix
    #../../modules/programs/editor/${vars.editor} # Set editor defined in variables.nix
    ../../modules/programs/editor/nvchad
    ../../modules/programs/editor/vscode # Set editor defined in variables.nix
    ../../modules/programs/cli/${vars.tuiFileManager} # Set file-manager defined in variables.nix
    ../../modules/programs/cli/tmux
    ../../modules/programs/cli/direnv
    ../../modules/programs/cli/lazygit
    ../../modules/programs/cli/cava
    ../../modules/programs/cli/fastfetch
    ../../modules/programs/cli/btop
    ../../modules/programs/media/discord/vesktop
    ../../modules/programs/media/discord/vencord
    ../../modules/programs/media/spicetify
    ../../modules/programs/electronics/kicad
    # ../../modules/programs/media/youtube-music
    #../../modules/programs/media/thunderbird
    ../../modules/programs/media/easyeffects
    ../../modules/programs/media/obs-studio
    ../../modules/programs/media/mpv
    ../../modules/programs/misc/tlp
    ../../modules/programs/misc/thunar
    ../../modules/programs/misc/lact # GPU fan, clock and power configuration
    ../../modules/programs/misc/mullvad
    ../../modules/programs/security/ghidra
    #../../modules/programs/security/ida
    ../../modules/programs/security/binja
    ../../modules/programs/media/QBittorrent

  ]
  ++ lib.optional (vars.games == true) ../../modules/core/games.nix;

  boot.initrd.systemd.enable = true;

  boot.initrd.luks.devices."luks-root" = {
    device = "/dev/disk/by-uuid/953ae8e7-75da-4255-9cd4-ebff324b6e2d";
    preLVM = true;
    crypttabExtraOpts = [ "tpm2-device=auto" "tpm2-measure=no"];
  };

  boot.initrd.availableKernelModules = [ "tpm_tis" "tpm_crb" ];

  # Mount Windows ESP (separate drive) to sync its boot files into /boot
  fileSystems."/mnt/windows-efi" = {
    device = "/dev/disk/by-uuid/4027-AB33";
    fsType = "vfat";
    options = [ "fmask=0133" "dmask=0022" "ro" "nofail" ];
  };

  # Sync Windows Boot Manager into /boot so systemd-boot/lanzaboote can detect it
  systemd.services.sync-windows-efi = {
    description = "Sync Windows EFI files to /boot";
    after = [ "mnt-windows\\x2defi.mount" "boot.mount" ];
    requires = [ "mnt-windows\\x2defi.mount" "boot.mount" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.rsync}/bin/rsync -a --delete /mnt/windows-efi/EFI/Microsoft /boot/EFI/";
    };
  };
}
