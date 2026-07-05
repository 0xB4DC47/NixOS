{ host, inputs, ... }:
let
  inherit (import ../hosts/${host}/variables.nix) sddmTheme;
in
{
  # Overlay custom derivations into nixpkgs so you can use pkgs.<name>
  additions =
    final: _prev:
    import ../pkgs {
      pkgs = final;
      inherit host;
    };

  # Patch NVIDIA 580.142 to remove linux/of_gpio.h include, removed in kernel 7.x.
  # Patches both the proprietary package (userspace) and the open kernel module package.
  nvidiaKernel7Fix = _final: prev: {
    linuxPackages_zen = prev.linuxPackages_zen.extend (_lpFinal: lpPrev: {
      nvidiaPackages = let
        patchOfGpio = pkg: pkg.overrideAttrs (old: {
          postUnpack = (old.postUnpack or "") + ''
            find . -name "nv-linux.h" -exec sed -i \
              's|#include <linux/of_gpio.h>|#define of_get_named_gpio(np, propname, index) (-ENODEV)|' {} +
          '';
        });
        latest = lpPrev.nvidiaPackages.latest;
      in lpPrev.nvidiaPackages // {
        latest = (patchOfGpio latest) // { open = patchOfGpio latest.open; };
      };
    });
  };

  # https://wiki.nixos.org/wiki/Overlays
  modifications = final: prev: {
    nur = inputs.nur.overlays.default;
    unstable = import inputs.nixpkgs-unstable {
      system = final.system;
      config.allowUnfree = true;
    };
    vesktop = prev.vesktop.override {
      withSystemVencord = false;
      withMiddleClickScroll = true;
    };
    discord = prev.discord.override {
      withVencord = true;
      withOpenASAR = true;
      enableAutoscroll = true;
    };
  };
}
