{ config, pkgs, ... }:

{
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    
    sharedModules = [
      {
        # We use the chromium module logic
        programs.brave = {
          enable = true;
          
          # We tell it to use the Brave package specifically
          package = pkgs.brave;

          extensions = [
            { id = "cjpalhdlnbpafiamejdnhcphjbkeiagm"; } # uBlock Origin
            { id = "kkmlkkjojmombglmlpbpapmhcaljjkde"; } # Zhongwen
            { id = "bfogiafebfohielmmehodmfbbebbbpei"; } # Keeper
            { id = "hfjbmagddngcpeloejdejnfgbamkjaeg"; } # Vimium-C 
          ];

          commandLineArgs = [
            "--disable-features=WebRtcAllowFullProxiedAddress"
            "--enable-features=TouchpadOverscrollHistoryNavigation"
            "--password-store=basic"
          ];
          
          #extraConfig = {
          #  "BraveRewardsDisabled" = true;
          #  "BraveWalletDisabled" = true;
          #  "BraveVPNDisabled" = true;
          #  "BraveAIChatEnabled" = false;
          #  "IPFSEnabled" = false;
          #  "TorDisabled" = true; # Set to true if you want a truly 'plain' browser
          #  "ShowFullUrlsInAddressBar" = true;
          #  "PasswordManagerEnabled" = false; # Optional: if you use Bitwarden/Keeper instead
          #};
        };
      }
    ];
  };
}
