{ ... }:
{
  services.kanata = {
    enable = true;
    keyboards = {
      internalKeyboard = {
        extraDefCfg = "process-unmapped-keys yes"; 
        config = ''
          ;; 1. Define the physical keys (the "input")
          (defsrc
            caps  tab   lalt  lmet   h    j    k    l
          )

          ;; 2. Define the behaviors
          (defalias
            escctrl (tap-hold 200 200 esc lctl)
            tabnav  (tap-hold 200 200 tab (layer-toggle nav))
          )

          ;; 3. The Base Layer
          ;; Note: lmet and lalt are swapped here compared to defsrc
          (deflayer base
            @escctrl @tabnav lmet lalt  h    j    k    l
          )

          ;; 4. The Navigation Layer
          ;; _ means "transparent" - it uses the behavior from the base layer
          (deflayer nav
            _        _       _    _    left down up  right
          )
        '';
      };
    };
  };
}
