{ pkgs, host, lib, ... }:
let
  vars = import ../../hosts/${host}/variables.nix;
in 
{
  boot = {
    # Filesystems support
    supportedFilesystems = [
      "ntfs"
      "exfat"
      "ext4"
      "fat32"
      "btrfs"
    ];
    tmp.cleanOnBoot = true;
    kernelPackages = pkgs.linuxPackages_zen; # _latest, _zen, _xanmod_latest, _hardened, _rt, _OTHER_CHANNEL, etc.
    kernelParams = [
      "preempt=full" # lower latency but less throughput
    ];
    loader = {
      efi.canTouchEfiVariables = true;
      efi.efiSysMountPoint = "/boot";
      timeout = 5; # null == Display bootloader indefinitely until user selects OS; 0 == skip unless space is held.
      grub = {
        #enable = true;
        enable = if vars.secureBoot then false else true;
        device = "nodev";
        efiSupport = true;
        useOSProber = true;
        gfxmodeEfi = "2715x1527"; # for 4k: 3840x2160
        gfxmodeBios = "2715x1527"; # for 4k: 3840x2160
        theme = pkgs.stdenv.mkDerivation {
          pname = "distro-grub-themes";
          version = "3.1";
          src = pkgs.fetchFromGitHub {
            owner = "AdisonCavani";
            repo = "distro-grub-themes";
            rev = "v3.1";
            hash = "sha256-ZcoGbbOMDDwjLhsvs77C7G7vINQnprdfI37a9ccrmPs=";
          };
          installPhase = "cp -r customize/nixos $out";
        };
      };
      systemd-boot.enable = lib.mkForce false;
    };

    lanzaboote = lib.mkIf (vars.secureBoot) {
      enable = true;
      pkiBundle = "/var/lib/sbctl";
      autoGenerateKeys = {
        enable = true;
      };
      autoEnrollKeys = {
        enable = true;
        autoReboot = true;
      };
    };

    # Appimage Support
    binfmt.registrations.appimage = {
      wrapInterpreterInShell = false;
      interpreter = "${pkgs.appimage-run}/bin/appimage-run";
      recognitionType = "magic";
      offset = 0;
      mask = ''\xff\xff\xff\xff\x00\x00\x00\x00\xff\xff\xff'';
      magicOrExtension = ''\x7fELF....AI\x02'';
    };
  };
  environment.systemPackages = lib.optionals (vars.secureBoot) [
    pkgs.sbctl
    pkgs.tpm2-tools
  ];
}
