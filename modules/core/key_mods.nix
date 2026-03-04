{ ... }:
{
  services.kanata = {
    enable = true;
    keyboards = {
      internalKeyboard = {
        extraDefCfg = "process-unmapped-keys yes"; 
        config = ''
          ;; 1. Define the physical keys we are intercepting
          (defsrc
            caps lalt lmet
          )

          ;; 2. Define the behavior for Caps Lock (Tap=Esc, Hold=Ctrl)
          (defalias
            escctrl (tap-hold 200 200 esc lctl)
          )

          ;; 3. Create the layer where the remapping happens
          (deflayer base
            @escctrl lmet lalt
          )
        '';
      };
    };
  };
}


