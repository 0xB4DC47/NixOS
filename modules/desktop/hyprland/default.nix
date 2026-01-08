{
  host,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  inherit (import ../../../hosts/${host}/variables.nix)
    waybarTheme
    browser
    terminal
    tuiFileManager
    kbdLayout
    kbdVariant
    defaultWallpaper
  ;
  #hyprPkg = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland; # this targets unstable master branch
  hyprPkg = pkgs.hyprland;
  
in
{
  imports = [
    ../../themes/Catppuccin # Catppuccin GTK and QT themes
    ./programs/waybar/${waybarTheme}.nix
    ./programs/wlogout
    ./programs/rofi
    ./programs/hypridle
    ./programs/hyprlock
    ./programs/swaync
    # ./programs/dunst
  ];

  nix.settings = {
    substituters = [ "https://hyprland.cachix.org" ];
    trusted-public-keys = [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];
  };

  systemd.user.services.hyprpolkitagent = {
    description = "Hyprpolkitagent - Polkit authentication agent";
    wantedBy = [ "graphical-session.target" ];
    wants = [ "graphical-session.target" ];
    after = [ "graphical-session.target" ];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.hyprpolkitagent}/libexec/hyprpolkitagent";
      Restart = "on-failure";
      RestartSec = 1;
      TimeoutStopSec = 10;
    };
  };
  services.displayManager.defaultSession = "hyprland";

  programs.hyprland = {
    enable = true;
    # withUWSM = true;
  };

  home-manager.sharedModules =
    let
      inherit (lib) getExe getExe';
    in
    [
      (
        { config, ... }:
        {
          xdg.portal = {
            enable = true;
            extraPortals = with pkgs; [
              xdg-desktop-portal-gtk
            ];
            xdgOpenUsePortal = true;
            configPackages = [ config.wayland.windowManager.hyprland.package ];
            config.hyprland = {
              default = [
                "hyprland"
                "gtk"
              ];
              "org.freedesktop.impl.portal.OpenURI" = "gtk";
              "org.freedesktop.impl.portal.FileChooser" = "gtk";
              "org.freedesktop.impl.portal.Print" = "gtk";
            };
          };

          home.packages = with pkgs; [
            swww
            hyprpicker
            cliphist
            wf-recorder
            grimblast
            slurp
            swappy
            libnotify
            brightnessctl
            networkmanagerapplet
            pamixer
            pavucontrol
            playerctl
            waybar
            wtype
            wl-clipboard
            xdotool
            yad
            socat # for and autowaybar.sh
            jq # for and autowaybar.sh
          ];

          xdg.configFile."hypr/icons" = {
            source = ./icons;
            recursive = true;
          };

          # Set wallpaper
          services.swww.enable = true;

          #test later systemd.user.targets.hyprland-session.Unit.Wants = [ "xdg-desktop-autostart.target" ];
          wayland.windowManager.hyprland = {
            enable = true;
            package = hyprPkg;
            plugins = [
              #inputs.hyprland-plugins.packages.${pkgs.stdenv.hostPlatform.system}.hyprexpo
              #pkgs.hyprlandPlugins.hyprexpo # this seems to only works if plugin is targeting unstable. Will skip this plugin for now
              # inputs.hyprland-plugins.packages.${pkgs.stdenv.hostPlatform.system}.hyprwinwrap
              # inputs.hyprsysteminfo.packages.${pkgs.stdenv.hostPlatform.system}.default
            ];
            systemd = {
              enable = true;
              variables = [ "--all" ];
            };
            settings = {
              "$mainMod" = "SUPER";
              "$term" = "${getExe pkgs.${terminal}}";
              "$editor" = "code --disable-gpu";
              "$fileManager" = "$term --class \"tuiFileManager\" -e ${tuiFileManager}";
              "$browser" = browser;

              env = [
                "XDG_CURRENT_DESKTOP,Hyprland"
                "XDG_SESSION_DESKTOP,Hyprland"
                "XDG_SESSION_TYPE,wayland"
                "GDK_BACKEND,wayland,x11,*"
                "NIXOS_OZONE_WL,1"
                "ELECTRON_OZONE_PLATFORM_HINT,wayland"
                "MOZ_ENABLE_WAYLAND,1"
                "OZONE_PLATFORM,wayland"
                "EGL_PLATFORM,wayland"
                "CLUTTER_BACKEND,wayland"
                "SDL_VIDEODRIVER,wayland"
                "QT_QPA_PLATFORM,wayland;xcb"
                "QT_WAYLAND_DISABLE_WINDOWDECORATION,1"
                "QT_QPA_PLATFORMTHEME,qt6ct"
                "QT_AUTO_SCREEN_SCALE_FACTOR,1"
                "QT_ENABLE_HIGHDPI_SCALING,1"
                "WLR_RENDERER_ALLOW_SOFTWARE,1"
                "NIXPKGS_ALLOW_UNFREE,1"
                "QT_IM_MODULE,fcitx" # Testing Added for possible chinese language support
                "GTK_IM_MODULE,fcitx" # Testing Added for possible chinese language support
                "XMODIFIERS,@im=fcitx" # Testing Added for possible chinese language support
                "SDL_IM_MODULE,fcitx" # Testing Added for possible chinese language support
                "GLFW_IM_MODULE,ibus" # Testing Added for possible chinese language support
                #"GTK_ENABLE_PRIMARY_PASTE,0" # Adding this to hopefully remove the middle click to paste
              ];
              exec-once =
                let
                  wallpaper = pkgs.callPackage ./scripts/wallpaper.nix { inherit defaultWallpaper; };
                in
                [
                  "[workspace 1 silent] ${terminal}"
                  "[workspace 5 silent] ${browser}"
                  "[workspace 10 silent] vesktop" # discord 
                  #"[workspace 6 silent] spotify"
                  #"[workspace special silent] ${browser} --private-window"
                  #"[workspace special silent] ${terminal}"

                  "${lib.getExe wallpaper}"
                  "waybar"
                  "swaync"
                  #"hyprctl plugin load ${inputs.hyprland-plugins.packages.${pkgs.stdenv.hostPlatform.system}.hyprexpo}/lib/libhyprexpo.so"
                  "nm-applet --indicator"
                  # "wl-clipboard-history -t"
                  "${getExe' pkgs.wl-clipboard "wl-paste"} --type text --watch cliphist store" # clipboard store text data
                  "${getExe' pkgs.wl-clipboard "wl-paste"} --type image --watch cliphist store" # clipboard store image data
                  "rm '$XDG_CACHE_HOME/cliphist/db'" # Clear clipboard
                  "${./scripts/batterynotify.sh}" # battery notification
                  #"${./scripts/autowaybar.sh}" # uncomment packages at the top
                  "polkit-agent-helper-1"
                  "pamixer --set-volume 100"
                ];
              input = {
                kb_layout = "${kbdLayout}";
                kb_variant = "${kbdVariant}";
                repeat_delay = 275; # or 212
                repeat_rate = 35;
                numlock_by_default = true;

                follow_mouse = 1;

                touchpad.natural_scroll = false;

                tablet.output = "current";

                sensitivity = 0; # -1.0 - 1.0, 0 means no modification.
                force_no_accel = true;
              };
              general = {
                gaps_in = 4;
                gaps_out = 8;
                border_size = 3;
                #"col.active_border" = "rgba(ca9ee6ff) rgba(f2d5cfff) 45deg";
                #"col.inactive_border" = "rgba(b4befecc) rgba(6c7086cc) 45deg";
                "col.active_border" = "rgba(ff00ffff) rgba(8800ffff) 45deg"; 
                "col.inactive_border" = "rgba(595959aa)"; # Dimmer inactive border
                resize_on_border = true;
                layout = "dwindle"; # dwindle or master
                # allow_tearing = true; # Allow tearing for games (use immediate window rules for specific games or all titles)
              };
              decoration = {
                shadow.enabled = false;
                rounding = 10;
                dim_special = 0.3;
                blur = {
                  enabled = true;
                  special = true;
                  size = 6; # 6
                  passes = 2; # 3
                  new_optimizations = true;
                  ignore_opacity = true;
                  xray = false;
                };
              };
              group = {
                "col.border_active" = "rgba(ca9ee6ff) rgba(f2d5cfff) 45deg";
                "col.border_inactive" = "rgba(b4befecc) rgba(6c7086cc) 45deg";
                "col.border_locked_active" = "rgba(ca9ee6ff) rgba(f2d5cfff) 45deg";
                "col.border_locked_inactive" = "rgba(b4befecc) rgba(6c7086cc) 45deg";
              };
              layerrule = [
                "blur,rofi"
                "ignorezero,rofi"
                "ignorealpha 0.7,rofi"
                "blur,swaync-control-center"
                "ignorezero,swaync-control-center"
                "ignorealpha 0.7,swaync-control-center"
                "blur,swaync-notification-window"
                "ignorezero,swaync-notification-window"
              ];

              animations = {
                enabled = true;
                #enabled = false;
                bezier = [
                  "linear, 0, 0, 1, 1"
                  "md3_standard, 0.2, 0, 0, 1"
                  "md3_decel, 0.05, 0.7, 0.1, 1"
                  "md3_accel, 0.3, 0, 0.8, 0.15"
                  "overshot, 0.05, 0.9, 0.1, 1.1"
                  "crazyshot, 0.1, 1.5, 0.76, 0.92"
                  "hyprnostretch, 0.05, 0.9, 0.1, 1.0"
                  "fluent_decel, 0.1, 1, 0, 1"
                  "easeInOutCirc, 0.85, 0, 0.15, 1"
                  "easeOutCirc, 0, 0.55, 0.45, 1"
                  "easeOutExpo, 0.16, 1, 0.3, 1"
                ];
                animation = [
                  "windows, 1, 3, md3_decel, popin 60%"
                  "border, 1, 10, default"
                  "fade, 1, 2.5, md3_decel"
                  # "workspaces, 1, 3.5, md3_decel, slide"
                  "workspaces, 1, 3.5, easeOutExpo, slide"
                  # "workspaces, 1, 7, fluent_decel, slidefade 15%"
                  # "specialWorkspace, 1, 3, md3_decel, slidefadevert 15%"
                  "specialWorkspace, 1, 3, md3_decel, slidevert"
                ];
              };
              render = {
                direct_scanout = 0; # 0 = off, 1 = on, 2 = auto (on with content type ‘game’)
              };
              ecosystem = {
                no_update_news = true;
                no_donation_nag = true;
              };
              misc = {
                disable_hyprland_logo = true;
                mouse_move_focuses_monitor = true;
                swallow_regex = "^(Alacritty|kitty)$";
                enable_swallow = true;
                vfr = true; # always keep on
                vrr = 2; # enable variable refresh rate (0=off, 1=on, 2=fullscreen only, 3 = fullscreen games/media)
              };
              xwayland.force_zero_scaling = true; # setting to true to hopefully fix uni2 resolution issue
              gestures = {
                gesture = [
                  "3, horizontal, workspace"
                ];
              };
              cursor = {
                inactive_timeout = 1;
              };
              dwindle = {
                pseudotile = true;
                preserve_split = true;
              };
              master = {
                new_status = "master";
                new_on_top = true;
                mfact = 0.5;
              };
              plugin = {
                hyprexpo = {
                  columns = 1;
                  gap_size = 5;
                  bg_col = "rgb(111111)";
                  workspace_method = "center current"; # [center current/first or [m+1/m-1]]
                  enable_gesture = true; # lets you use gestures to open it
                  gesture_fingers = 3;  # 3 finger swipe
                  gesture_distance = 300;
                };
              };
              windowrulev2 = [
                #"noanim, class:^(Rofi)$"
                "tile,title:(.*)(Godot)(.*)$"
                # "workspace 1, class:^(kitty|Alacritty|org.wezfurlong.wezterm)$"
                # "workspace 2, class:^(code|VSCodium|code-url-handler|codium-url-handler)$"
                # "workspace 3, class:^(krita)$"
                # "workspace 3, title:(.*)(Godot)(.*)$"
                # "workspace 3, title:(GNU Image Manipulation Program)(.*)$"
                # "workspace 3, class:^(factorio)$"
                # "workspace 3, class:^(steam)$"
                # "workspace 5, class:^(firefox|floorp|zen|zen-beta)$"
                # "workspace 6, class:^(Spotify)$"
                # "workspace 6, title:(.*)(Spotify)(.*)$"

                # Can use FLOAT FLOAT for active and inactive or just FLOAT
                "opacity 1.00 1.00,class:^(firefox|Brave-browser|floorp|zen|zen-beta)$"
                "opacity 1.00 1.00,class:^(discord)$" # Discord-Electron
                "opacity 1.00 1.00,class:^(WebCord)$" # WebCord-Electron
                #"opacity 0.80 0.70,class:^(Steam|steam|steamwebhelper)$"
                "opacity 0.90 0.90,class:^(Spotify|spotify)$"
                "opacity 0.90 0.90,title:(.*)(Spotify)(.*)$"
                "opacity 0.90 0.80,class:^(Emacs)$"
                "opacity 0.90 0.80,class:^(gcr-prompter)$" # keyring prompt
                "opacity 0.90 0.80,title:^(Hyprland Polkit Agent)$" # polkit prompt
                "opacity 0.90 0.80,class:^(obsidian)$"
                "opacity 0.90 0.80,class:^(Lutris|lutris|net.lutris.Lutris)$"
                "opacity 0.80 0.70,class:^(kitty|alacritty|Alacritty|org.wezfurlong.wezterm)$"
                "opacity 0.80 0.70,class:^(nvim-wrapper)$"
                "opacity 0.80 0.70,class:^(gnome-disks)$"
                "opacity 0.80 0.70,class:^(org.gnome.Nautilus|Thunar|thunar|pcmanfm)$"
                "opacity 0.80 0.70,class:^(thunar-volman-settings)$"
                "opacity 0.80 0.70,class:^(org.gnome.FileRoller)$"
                "opacity 0.80 0.70,class:^(io.github.ilya_zlobintsev.LACT)$"
                "opacity 0.80 0.70,title:^(Kvantum Manager)$"
                #"opacity 0.80 0.70,class:^(VSCodium|codium-url-handler)$"
                #"opacity 0.80 0.70,class:^(code|code-url-handler)$"
                "opacity 0.80 0.70,class:^(tuiFileManager)$"
                "opacity 0.80 0.70,class:^(org.kde.dolphin)$"
                "opacity 0.80 0.70,class:^(org.kde.ark)$"
                "opacity 0.80 0.70,class:^(nwg-look)$"
                "opacity 0.80 0.70,class:^(qt5ct|qt6ct)$"
                "opacity 0.80 0.70,class:^(yad)$"

                "opacity 0.90 0.80,class:^(com.github.rafostar.Clapper)$" # Clapper-Gtk
                "opacity 0.80 0.70,class:^(com.github.tchx84.Flatseal)$" # Flatseal-Gtk
                "opacity 0.80 0.70,class:^(hu.kramo.Cartridges)$" # Cartridges-Gtk
                "opacity 0.80 0.70,class:^(com.obsproject.Studio)$" # Obs-Qt
                "opacity 0.80 0.70,class:^(gnome-boxes)$" # Boxes-Gtk
                "opacity 0.80 0.70,class:^(app.drey.Warp)$" # Warp-Gtk
                "opacity 0.80 0.70,class:^(net.davidotek.pupgui2)$" # ProtonUp-Qt
                "opacity 0.80 0.70,class:^(Signal)$" # Signal-Gtk
                "opacity 0.80 0.70,class:^(io.gitlab.theevilskeleton.Upscaler)$" # Upscaler-Gtk

                "opacity 0.80 0.70,class:^(pavucontrol)$"
                "opacity 0.80 0.70,class:^(org.pulseaudio.pavucontrol)$"
                "opacity 0.80 0.70,class:^(blueman-manager)$"
                "opacity 0.80 0.70,class:^(.blueman-manager-wrapped)$"
                "opacity 0.80 0.70,class:^(nm-applet)$"
                "opacity 0.80 0.70,class:^(nm-connection-editor)$"
                "opacity 0.80 0.70,class:^(org.kde.polkit-kde-authentication-agent-1)$"

                # Block discord and browsers from screenshare/screenshots
                # "noscreenshare,class:^(firefox|Brave-browser|floorp|zen|zen-beta)$"
                # "noscreenshare,class:^(discord)$"

                # Float and pin Picture-in-Picture in browsers
                "float,title:^(Picture-in-Picture)$,class:^(zen|zen-beta|floorp|firefox)$"
                "pin,title:^(Picture-in-Picture)$,class:^(zen|zen-beta|floorp|firefox)$"

                "content game, tag:games"
                "tag +games, content:game"
                "tag +games, class:^(steam_app.*|steam_app_\d+)$"
                "tag +games, class:^(gamescope)$"
                "tag +games, class:(Waydroid)"
                "tag +games, class:(osu!)"

                # Games
                "syncfullscreen,tag:games"
                "fullscreen,tag:games"
                "noborder 1,tag:games"
                "noshadow,tag:games"
                "noblur,tag:games"
                "noanim,tag:games"

                "float,class:^(qt5ct)$"
                "float,class:^(nwg-look)$"
                "float,class:^(org.kde.ark)$"
                "float,class:^(Signal)$" # Signal-Gtk
                "float,class:^(com.github.rafostar.Clapper)$" # Clapper-Gtk
                "float,class:^(app.drey.Warp)$" # Warp-Gtk
                "float,class:^(net.davidotek.pupgui2)$" # ProtonUp-Qt
                "float,class:^(eog)$" # Imageviewer-Gtk
                "float,class:^(io.gitlab.theevilskeleton.Upscaler)$" # Upscaler-Gtk
                "float,class:^(yad)$"
                "float,class:^(pavucontrol)$"
                "float,class:^(blueman-manager)$"
                "float,class:^(.blueman-manager-wrapped)$"
                "float,class:^(nm-applet)$"
                "float,class:^(nm-connection-editor)$"
                "float,class:^(org.kde.polkit-kde-authentication-agent-1)$"
              ];
              binde = [
                # Resize windows
                "$mainMod SHIFT, right, resizeactive, 30 0"
                "$mainMod SHIFT, left, resizeactive, -30 0"
                "$mainMod SHIFT, up, resizeactive, 0 -30"
                "$mainMod SHIFT, down, resizeactive, 0 30"

                # Resize windows with hjkl keys
                "$mainMod SHIFT, l, resizeactive, 30 0"
                "$mainMod SHIFT, h, resizeactive, -30 0"
                "$mainMod SHIFT, k, resizeactive, 0 -30"
                "$mainMod SHIFT, j, resizeactive, 0 30"

                # Functional keybinds
                ",XF86MonBrightnessDown,exec,brightnessctl set 2%-"
                ",XF86MonBrightnessUp,exec,brightnessctl set +2%"
                ",XF86AudioLowerVolume,exec,pamixer -d 2"
                ",XF86AudioRaiseVolume,exec,pamixer -i 2"
              ];
              bind =
                let
                  autoclicker = pkgs.callPackage ./scripts/autoclicker.nix { };
                in
                [
                  # Keybinds help menu
                  "$mainMod, question, exec, ${./scripts/keybinds.sh}"
                  "$mainMod, slash, exec, ${./scripts/keybinds.sh}"
                  "$mainMod CTRL, K, exec, ${./scripts/keybinds.sh}"

                  "$mainMod, F8, exec, kill $(cat /tmp/auto-clicker.pid) 2>/dev/null || ${lib.getExe autoclicker} --cps 40"
                  # "$mainMod ALT, mouse:276, exec, kill $(cat /tmp/auto-clicker.pid) 2>/dev/null || ${lib.getExe autoclicker} --cps 60"

                  # Night Mode (lower value means warmer temp)
                  "$mainMod, F9, exec, ${getExe pkgs.hyprsunset} --temperature 3500" # good values: 3500, 3000, 2500
                  "$mainMod, F10, exec, pkill hyprsunset"

                  # Window/Session actions
                  "$mainMod, W, exec, ${./scripts/dontkillsteam.sh}" # killactive, kill the window on focus
                  "$mainMod SHIFT, W, exec, ${./scripts/wipe-workspace.sh}"
                  "ALT, F4, exec, ${./scripts/dontkillsteam.sh}" # killactive, kill the window on focus
                  "$mainMod CTRL ALT, delete, exit" # kill hyprland session
                  "$mainMod SHIFT, F, togglefloating" # toggle the window on focus to float
                  "$mainMod SHIFT, G, togglegroup" # toggle the window to be a window group
                  "ALT, return, fullscreen" # toggle the window on focus to fullscreen
                  "$mainMod, F, fullscreen" # toggle the window on focus to fullscreen
                  "$mainMod ALT, L, exec, hyprlock" # lock screen
                  "$mainMod, backspace, exec, pkill -x wlogout || wlogout -b 4" # logout menu
                  "$CONTROL, ESCAPE, exec, pkill waybar || waybar" # toggle waybar

                  # Hypr

                  # Applications/Programs
                  "$mainMod, Return, exec, $term"
                  "$mainMod, T, exec, $term -e tmux new-session -A -s main"
                  "$mainMod, E, exec, $fileManager"
                  "$mainMod, C, exec, $editor"
                  "$mainMod, B, exec, $browser"
                  "$mainMod SHIFT, S, exec, spotify"
                  "$mainMod SHIFT, Y, exec, youtube-music"
                  "$CONTROL ALT, DELETE, exec, $term -e '${getExe pkgs.btop}'" # System Monitor
                  "$mainMod CTRL, C, exec, hyprpicker --autocopy --format=hex" # Colour Picker

                  #"$mainMod, A, hyprexpo:expo, toggle" # toggle expo window zoomout
                  "$mainMod, SPACE, exec, launcher drun" # launch desktop applications
                  "$mainMod ALT, B, exec, launcher wallpaper" # launch wallpaper switcher
                  "$mainMod, semi-colon, exec, launcher emoji" # launch emoji picker
                  "$mainMod SHIFT, T, exec, launcher tmux" # launch tmux sessions
                  "$mainMod, G, exec, launcher games" # game launcher
                  # "$mainMod, tab, exec, launcher window" # switch between desktop applications
                  # "$mainMod, R, exec, launcher file" # brrwse system files
                  "$mainMod ALT, K, exec, ${./scripts/keyboardswitch.sh}" # change keyboard layout
                  "$mainMod SHIFT, N, exec, swaync-client -t -sw" # swayNC panel
                  "$mainMod SHIFT, Q, exec, swaync-client -t -sw" # swayNC panel
                  "$mainMod ALT, G, exec, ${./scripts/gamemode.sh}" # disable hypr effects for gamemode
                  "$mainMod, V, exec, ${./scripts/ClipManager.sh}" # Clipboard Manager
                  "$mainMod, M, exec, ${./scripts/rofimusic.sh}" # online music

                  # Screenshot/Screencapture
                  "$mainMod SHIFT, R, exec, ${./scripts/screen-record.sh} a" # Screen Record (area select)
                  "$mainMod CTRL, R, exec, ${./scripts/screen-record.sh} m" # Screen Record (monitor select)
                  "$mainMod, P, exec, ${./scripts/screenshot.sh} s" # drag to snip an area / click on a window to print it
                  "$mainMod CTRL, P, exec, ${./scripts/screenshot.sh} sf" # frozen screen, drag to snip an area / click on a window to print it
                  "$mainMod, print, exec, ${./scripts/screenshot.sh} m" # print focused monitor
                  "$mainMod ALT, P, exec, ${./scripts/screenshot.sh} p" # print all monitor outputs

                  # Functional keybinds
                  ",xf86Sleep, exec, systemctl suspend" # Put computer into sleep mode
                  ",XF86AudioMicMute,exec,pamixer --default-source -t" # mute mic
                  ",XF86AudioMute,exec,pamixer -t" # mute audio
                  ",XF86AudioPlay,exec,playerctl play-pause" # Play/Pause media
                  ",XF86AudioPause,exec,playerctl play-pause" # Play/Pause media
                  ",xf86AudioNext,exec,playerctl next" # go to next media
                  ",xf86AudioPrev,exec,playerctl previous" # go to previous media

                  # ",xf86AudioNext,exec,${./scripts/MediaCtrl.sh} next" # go to next media
                  # ",xf86AudioPrev,exec,${./scripts/MediaCtrl.sh} previous" # go to previous media
                  # ",XF86AudioPlay,exec,${./scripts/MediaCtrl.sh} play-pause" # go to next media
                  # ",XF86AudioPause,exec,${./scripts/MediaCtrl.sh} play-pause" # go to next media

                  # to switch between windows in a floating workspace
                  "$mainMod, Tab, cyclenext"
                  "$mainMod, Tab, bringactivetotop"

                  # Switch workspaces relative to the active workspace with mainMod + CTRL + [←→]
                  "$mainMod CTRL, right, workspace, r+1"
                  "$mainMod CTRL, left, workspace, r-1"

                  # move to the first empty workspace instantly with mainMod + CTRL + [↓]
                  "$mainMod CTRL, down, workspace, empty"

                  # Move focus with mainMod + arrow keys
                  "$mainMod, left, movefocus, l"
                  "$mainMod, right, movefocus, r"
                  "$mainMod, up, movefocus, u"
                  "$mainMod, down, movefocus, d"
                    #"ALT, Tab, movefocus, d"
                  "ALT, Tab, changegroupactive, f"
                  "ALT SHIFT, Tab, changegroupactive, b"


                  # This might be nice to toggle a system wide floating mode similar to pop-os
                  #"$mainMod, Y, exec, hprctl keybword general:layout 'float'"
                  #"$mainMod SHIFT, Y, exec hyprctl keybword general:layout 'dwindle'"

                  # Move focus with mainMod + HJKL keys
                  "$mainMod, h, movefocus, l"
                  "$mainMod, l, movefocus, r"
                  "$mainMod, k, movefocus, u"
                  "$mainMod, j, movefocus, d"

                  # Go to workspace 6 and 7 with mouse side buttons
                  #"$mainMod, mouse:276, workspace, 5"
                  #"$mainMod, mouse:275, workspace, 6"
                  #"$mainMod SHIFT, mouse:276, movetoworkspace, 5"
                  #"$mainMod SHIFT, mouse:275, movetoworkspace, 6"
                  #"$mainMod CTRL, mouse:276, movetoworkspacesilent, 5"
                  #"$mainMod CTRL, mouse:275, movetoworkspacesilent, 6"

                  # Rebuild NixOS with a KeyBind
                  "$mainMod, U, exec, $term -e rebuild"

                  # Scroll through existing workspaces with mainMod + scroll
                  "$mainMod, mouse_down, workspace, e+1"
                  "$mainMod, mouse_up, workspace, e-1"

                  # Move active window to a relative workspace with mainMod + CTRL + ALT + [←→]
                  "$mainMod CTRL ALT, right, movetoworkspace, r+1"
                  "$mainMod CTRL ALT, left, movetoworkspace, r-1"

                  # Move active window around current workspace with mainMod + SHIFT + CTRL [←→↑↓]
                  "$mainMod SHIFT $CONTROL, left, movewindow, l"
                  "$mainMod SHIFT $CONTROL, right, movewindow, r"
                  "$mainMod SHIFT $CONTROL, up, movewindow, u"
                  "$mainMod SHIFT $CONTROL, down, movewindow, d"

                  # Move active window around current workspace with mainMod + SHIFT + CTRL [HLJK]
                  "$mainMod SHIFT $CONTROL, H, movewindow, l"
                  "$mainMod SHIFT $CONTROL, L, movewindow, r"
                  "$mainMod SHIFT $CONTROL, K, movewindow, u"
                  "$mainMod SHIFT $CONTROL, J, movewindow, d"

                  # Special workspaces (scratchpad)
                  "$mainMod CTRL, S, movetoworkspacesilent, special"
                  "$mainMod ALT, S, movetoworkspacesilent, special"
                  "$mainMod, S, togglespecialworkspace,"
                ]
                ++ (builtins.concatLists (
                  builtins.genList (
                    x:
                    let
                      ws =
                        let
                          c = (x + 1) / 10;
                        in
                        builtins.toString (x + 1 - (c * 10));
                    in
                    [
                      "$mainMod, ${ws}, workspace, ${toString (x + 1)}"
                      "$mainMod SHIFT, ${ws}, movetoworkspace, ${toString (x + 1)}"
                      "$mainMod CTRL, ${ws}, movetoworkspacesilent, ${toString (x + 1)}"
                    ]
                  ) 10
                ));
              bindm = [
                # Move/Resize windows with mainMod + LMB/RMB and dragging
                "$mainMod, mouse:272, movewindow"
                "$mainMod, mouse:273, resizewindow"
              ];

              binds = {
                workspace_back_and_forth = 0;
                #allow_workspace_cycles=1
                #pass_mouse_when_bound=0
              };

              # =============================================================
              # MONITOR CONFIGURATION - Updated for your setup
              # =============================================================
              # Layout (left to right):
              #   DP-5 (vertical) -> DP-4 (main) -> HDMI-A-2 (right)
              #
              # Positions calculated:
              #   - DP-5 (vertical 1080x1920): x=0
              #   - DP-4 (2560x1440): x=1080 (after vertical monitor width)
              #   - HDMI-A-2 (1920x1080): x=3640 (1080+2560)
              # =============================================================
              monitor = [
                # Fallback for any other monitors
                ",preferred,auto,1"

                # Left monitor - BenQ GW2490 (vertical/portrait mode)
                # Serial: F3S0291101Q, transform 1 = 90° rotation
                #"desc:BNQ BenQ GW2490 F3S0291101Q,preferred,0x0,1,transform,1"
                #"DP-5,1080x1920@60, 0x0, 1, transform,1"
                #"DP-5,preferred, 0x0, 1, transform,1"

                # Main/Center monitor - Dell S2417DG
                # Serial: #ASP3oRncBhPd
                # Position: starts at x=1080 (width of rotated left monitor)
                #"desc:Dell Inc. Dell S2417DG #ASP3oRncBhPd,preferred,1080x0,1"
                #"DP-4,2560x1440@144,1080x0,1"

                # Right monitor - BenQ GW2490
                # Serial: ETGAR02706SL0
                # Position: starts at x=3640 (1080 + 2560)
                #"desc:BNQ BenQ GW2490 ETGAR02706SL0,preferred,3640x0,1"
                #"HDMI-A-2,preferred,3640x0,1"

                "desc:BNQ BenQ GW2490 ETGAR02706SL0,1920x1080@100.0,3640x367,1.0"
                "desc:Dell Inc. Dell S2417DG ##ASP3oRncBhPd,2560x1440@144.0,1080x220,1.0, vrr, 0"
                "desc:BNQ BenQ GW2490 F3S0291101Q,1920x1080@100.0,0x0,1.0"
                "desc:BNQ BenQ GW2490 F3S0291101Q,transform,1"
              ];
              # =============================================================
              # WORKSPACE CONFIGURATION - Updated for your monitors
              # =============================================================
              workspace = [
                # Main monitor (Dell S2417DG) - Primary workspaces 1-4
                "1,monitor:desc:Dell Inc. Dell S2417DG #ASP3oRncBhPd,default:true"
                "2,monitor:desc:Dell Inc. Dell S2417DG #ASP3oRncBhPd"
                "3,monitor:desc:Dell Inc. Dell S2417DG #ASP3oRncBhPd"
                "4,monitor:desc:Dell Inc. Dell S2417DG #ASP3oRncBhPd"

                # Left vertical monitor (BenQ GW2490 F3S0291101Q) - Workspaces 5-7
                "5,monitor:desc:BNQ BenQ GW2490 F3S0291101Q,default:true"
                "6,monitor:desc:BNQ BenQ GW2490 F3S0291101Q"
                "7,monitor:desc:BNQ BenQ GW2490 F3S0291101Q"

                # Right monitor (BenQ GW2490 ETGAR02706SL0) - Workspaces 8-10
                "8,monitor:desc:BNQ BenQ GW2490 ETGAR02706SL0,default:true"
                "9,monitor:desc:BNQ BenQ GW2490 ETGAR02706SL0"
                "10,monitor:desc:BNQ BenQ GW2490 ETGAR02706SL0"
              ];
            };
          };
        }
      )
    ];
}
