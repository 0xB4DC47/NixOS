{ host, pkgs, ... }:
pkgs.writeShellScriptBin "rebuild" ''
  # Colors for output
  RED='\033[0;31m'
  GREEN='\033[0;32m'
  NC='\033[0m' # No Color

  if [[ $EUID -eq 0 ]]; then
    echo "This script should not be executed as root! Exiting..."
    exit 1
  fi

  if [ -f "$HOME/NixOS/flake.nix" ]; then
    flake=$HOME/NixOS
  elif [ -f "/etc/nixos/flake.nix" ]; then
    flake=/etc/nixos
  else
    echo "Error: flake not found. ensure flake.nix exists in either $HOME/NixOS or /etc/nixos"
    exit 1
  fi
  echo -e "''${GREEN}Flake: $flake''${NC}"
  echo -e "''${GREEN}Host: ${host}''${NC}"
  currentUser=$(logname)

  # replace username variable in variables.nix with $USER
  sudo sed -i -e "s/username = \".*\"/username = \"$currentUser\"/" "$flake/hosts/${host}/variables.nix"

  if [ -f "/etc/nixos/hardware-configuration.nix" ]; then
    cat "/etc/nixos/hardware-configuration.nix" | sudo tee "$flake/hosts/${host}/hardware-configuration.nix" >/dev/null
  else
    sudo nixos-generate-config --show-hardware-config >"$flake/hosts/${host}/hardware-configuration.nix"
  fi

  sudo git -C "$flake" add hosts/${host}/hardware-configuration.nix

  # nh os switch --hostname "${host}"
  sudo nixos-rebuild switch --flake "$flake#${host}"

  # Re-enroll TPM LUKS key only if PCR 0/7 changed (firmware update or Secure Boot key change)
  LUKS_DEVICE=$(sudo blkid -t TYPE=crypto_LUKS -o device 2>/dev/null | head -1)
  if [ -n "$LUKS_DEVICE" ] && sudo cryptsetup luksDump "$LUKS_DEVICE" | grep -q tpm2; then
    PCR7_FILE="/var/lib/tpm-luks-pcr7"
    CURRENT_PCR7=$(sudo tpm2_pcrread sha256:0,7 2>/dev/null | grep -oP 'sha256:.*')
    SAVED_PCR7=""
    if [ -f "$PCR7_FILE" ]; then
      SAVED_PCR7=$(cat "$PCR7_FILE")
    fi
    if [ -n "$CURRENT_PCR7" ] && [ "$CURRENT_PCR7" = "$SAVED_PCR7" ]; then
      echo -e "''${GREEN}TPM LUKS key is still valid (PCR 0+7 unchanged), skipping re-enrollment.''${NC}"
    else
      echo -e "''${GREEN}Re-enrolling TPM LUKS key for $LUKS_DEVICE (PCR 0+7 changed)...''${NC}"
      sudo systemd-cryptenroll --wipe-slot=tpm2 --tpm2-device=auto --tpm2-pcrs=0+7 "$LUKS_DEVICE"
      echo "$CURRENT_PCR7" | sudo tee "$PCR7_FILE" >/dev/null
    fi
  fi

  echo
  read -rsn1 -p"$(echo -e "''${GREEN}Press any key to continue''${NC}")"
''
