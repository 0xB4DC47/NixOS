{ pkgs, lib, config, ... }:

{
  # Ensure unfree is allowed for the proprietary Krisp blob
  nixpkgs.config.allowUnfree = true;

  home-manager.sharedModules = [
    ({ ... }: {
      home.packages = [ pkgs.vesktop ];

      # Vesktop Settings
      xdg.configFile."vesktop/settings.json".text = builtins.toJSON {
        discordBranch = "stable";
        firstLaunch = false;
        minimizeToTray = true;
        arRPC = "on";
        # Required for Krisp/Noise Cancellation features to initialize correctly
        hardwareAcceleration = true;
        enableAutomaticVencord = true;
      };

      # Vencord Settings (This is where Krisp is actually toggled)
      # This writes to the internal Vencord configuration
      xdg.configFile."vesktop/settings/settings.json".text = builtins.toJSON {
        notifyAboutUpdates = false;
        autoUpdate = false;
        autoUpdateInterval = 1440;
        enabledPlugins = {
          # Enables the Noise Cancellation plugin structure
          VoiceMessages = true;
          # Many users find that 'Vencord' handles Krisp via the 'FakeKrisp' 
          # or by allowing the official Discord Krisp implementation
          FakeKrisp = true; 
          SettingsSync = false;
        };
      };

      # Optional: Match your Catppuccin theme in Vesktop
      xdg.configFile."vesktop/settings/quickCss.css".text = ''
        /* Optional: Basic Catppuccin-like accent for the noise cancel icons */
        .vencord-krisp-indicator {
          color: #ca9ee6;
        }
      '';
    })
  ];
}
