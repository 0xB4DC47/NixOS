{
  inputs,
  lib,
  pkgs,
  config,
  ...
}:
{
  # environment.systemPackages = with pkgs; [inputs.zen-browser.packages.${stdenv.hostPlatform.system}.default];
  home-manager.sharedModules = [
    (_: {
      imports = [ inputs.zen-browser.homeModules.beta ];
      xdg.mimeApps = {
        enable = true;
        defaultApplications = {
          "text/html" = "zen-beta.desktop";
          "x-scheme-handler/http" = "zen-beta.desktop";
          "x-scheme-handler/https" = "zen-beta.desktop";
          "x-scheme-handler/about" = "zen-beta.desktop";
          "x-scheme-handler/unknown" = "zen-beta.desktop";
        };
      };


      programs.zen-browser = {
        enable = true;
        #suppressXdgMigrationWarning = true; # No longer needed
        policies = import ./policies.nix { inherit lib; };
        languagePacks = [
          "en-US"
          "es-MX"
          "es-DO"
        ];
        profiles = {
          default = {
            id = 0; # 0 is the default profile; see also option "isDefault"
            name = "default"; # name as listed in about:profiles
            isDefault = true; # can be omitted; true if profile ID is 0
            settings = import ./settings.nix;
            bookmarks = import ./bookmarks.nix;
            search = import ./search.nix { inherit pkgs; };
            userChrome = builtins.readFile ./userChrome.css;
            userContent = builtins.readFile ./userContent.css;
            spacesForce = true;
            spaces = let 
              containers = config.programs.zen-browser.profiles."default".containers;
            in {
              "Main" = {
                id = "c6de089c-410d-4206-961d-ab11f988d40a";
                icon = "😀";
                position = 1000;
              };

              "Work" = {
                id = "cdd10fab-4fc5-494b-9041-325e5759195b";
                icon = "👷‍♂️";
                position = 2000;
              };
              "Game" = {
                id = "f446b76d-66f5-489a-8290-b0a283e216d8";
                icon = "🎮";
                position = 3000;
              };
              "Language" = {
                id = "78aabdad-8aae-4fe0-8ff0-2a0c6c4ccc24";
                icon = "📓";
                position = 4000;
              };
            };
            extraConfig = ''
              ${builtins.readFile "${inputs.betterfox}/Fastfox.js"}
              ${builtins.readFile "${inputs.betterfox}/Peskyfox.js"}
              ${builtins.readFile "${inputs.betterfox}/Securefox.js"}
              ${builtins.readFile "${inputs.betterfox}/Smoothfox.js"}
              lockPref("extensions.formautofill.addresses.enabled", false);
              lockPref("extensions.formautofill.creditCards.enabled", false);
              lockPref("dom.security.https_only_mode_pbm", true);
              lockPref("dom.security.https_only_mode_error_page_user_suggestions", true);
              lockPref("browser.firefox-view.feature-tour", "{\"screen\":\"\",\"complete\":true}");
              lockPref("identity.fxaccounts.enabled", false);
              lockPref("browser.tabs.firefox-view-next", false);
              lockPref("privacy.sanitize.sanitizeOnShutdown", false);
              lockPref("privacy.clearOnShutdown.cache", true);
              lockPref("privacy.clearOnShutdown.cookies", false);
              lockPref("privacy.clearOnShutdown.offlineApps", false);
              lockPref("browser.sessionstore.privacy_level", 0);
              lockPref("floorp.browser.sidebar.enable", false);
              lockPref("geo.enabled", false);
              lockPref("media.navigator.enabled", false);
              lockPref("dom.event.clipboardevents.enabled", false);
              lockPref("dom.event.contextmenu.enabled", false);
              lockPref("dom.battery.enabled", false);
              lockPref("extensions.enabledScopes", 15);
              lockPref("extensions.autoDisableScopes", 0);
              lockPref("browser.newtabpage.activity-stream.floorp.newtab.imagecredit.hide", true);
              lockPref("browser.newtabpage.activity-stream.floorp.newtab.releasenote.hide", true);
              lockPref("browser.search.separatePrivateDefault", true);
            '';
          };
        };
      };
    })
  ];
}
