{ pkgs, ... }: {
  programs.binary-ninja = {
    enable = true;
    package = pkgs.binary-ninja-personal-wayland.override {
      overrideSource = pkgs.requireFile {
        name = "binaryninja_personal_linux.zip";
        sha256 = "11rwavgcmr1l97pkvmq8y4qpih8d59dkh6f4m25bpnk7kv2msg87";
        message = ''
          Binary Ninja requires a personal license. Log in at https://binary.ninja,
          download the Linux zip, then run:
            nix-store --add-fixed sha256 ./binaryninja_personal_linux.zip
        '';
      };
    };
  };
}
