{ config, pkgs, ... }:

{
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    
    sharedModules = [
      {
        # We use the chromium module logic
        programs.chromium = {
          enable = true;
          
          # We tell it to use the Brave package specifically
          package = pkgs.brave;

          extensions = [
            { id = "cjpalhdlnbpafiamejdnhcphjbkeiagm"; } # uBlock Origin
            { id = "nngceckbapebfimnlniiiahkandclblb"; } # Bitwarden
          ];

          commandLineArgs = [
            "--disable-features=WebRtcAllowFullProxiedAddress"
            "--enable-features=TouchpadOverscrollHistoryNavigation"
          ];
        };
      }
    ];
  };
}
