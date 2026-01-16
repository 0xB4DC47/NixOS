{ pkgs, lib, config, ... }:
{
  home-manager.sharedModules = [
    ({ ... }: {
      services.easyeffects = {
        enable = true;
      };
      })
    ];
}

