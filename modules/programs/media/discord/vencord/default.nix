{ pkgs, ... }:
{
  home-manager.sharedModules = [
    (_: {
      home.packages = with pkgs; [
        (discord.override {
          withVencord = true;
        })
      ];
      xdg.configFile."Vencord/themes/catppuccin-mocha.css".text = ''
        /**
        * @name Catppuccin Mocha
        * @author winston#0001
        * @authorId 505490445468696576
        * @version 0.2.0
        * @description 🎮 Soothing pastel theme for Discord
        * @website https://github.com/catppuccin/discord
        * @invite r6Mdz5dpFc
        * **/

        @import url("https://catppuccin.github.io/discord/dist/catppuccin-mocha-mauve.theme.css");
      '';
      xdg.configFile."Vencord/themes/dtm-16.theme.css".text = ''
        /**
        * @name DTM-16 OldCord
        * @author 11pixels - XYZenix 
        * @authorId 505490445468696576
        * @version 7
        * @description A theme that tries to bring back the 2016 look of Discord
        * @website https://github.com/XYZenix/DTM-16
        * @invite r6Mdz5dpFc
        * **/
      '';
      xdg.configFile."Vencord/theme/system24-rose-pine.theme.css".text = ''
        /**
        * @name system24 (rosé pine moon) 
       * @description a tui-style discord theme. based on rosé pine moon theme (https://rosepinetheme.com).
       * @author refact0r
       * @version 2.0.0
       * @invite nz87hXyvcy
       * @website https://github.com/refact0r/system24
       * @source https://github.com/refact0r/system24/blob/master/theme/system24-rose-pine-moon.theme.css
       * @authorId 508863359777505290
       * @authorLink https://www.refact0r.dev
      */

      /* import theme modules */
      @import url('https://refact0r.github.io/system24/build/system24.css');

      body {
          /* font, change to \'\' for default discord font */
          --font: 'DM Mono'; /* change to ''' for default discord font */
          --code-font: 'DM Mono'; /* change to ''' for default discord font */
          font-weight: 300; /* text font weight. 300 is light, 400 is normal. DOES NOT AFFECT BOLD TEXT */
          letter-spacing: -0.05ch; /* decreases letter spacing for better readability. recommended on monospace fonts.*/

          /* sizes */
          --gap: 12px; /* spacing between panels */
          --divider-thickness: 4px; /* thickness of unread messages divider and highlighted message borders */
          --border-thickness: 2px; /* thickness of borders around main panels. DOES NOT AFFECT OTHER BORDERS */
          --border-hover-transition: 0.2s ease; /* transition for borders when hovered */

          /* animation/transition options */
          --animations: on; /* off: disable animations/transitions, on: enable animations/transitions */
          --list-item-transition: 0.2s ease; /* transition for list items */
          --dms-icon-svg-transition: 0.4s ease; /* transition for the dms icon */

          /* top bar options */
          --top-bar-height: var(--gap); /* height of the top bar (discord default is 36px, old discord style is 24px, var(--gap) recommended if button position is set to titlebar) */
          --top-bar-button-position: titlebar; /* off: default position, hide: hide buttons completely, serverlist: move inbox button to server list, titlebar: move inbox button to channel titlebar (will hide title) */
          --top-bar-title-position: off; /* off: default centered position, hide: hide title completely, left: left align title (like old discord) */
          --subtle-top-bar-title: off; /* off: default, on: hide the icon and use subtle text color (like old discord) */

          /* window controls */
          --custom-window-controls: off; /* off: default window controls, on: custom window controls */
          --window-control-size: 14px; /* size of custom window controls */

          /* dms button options */
          --custom-dms-icon: hide; /* off: use default discord icon, hide: remove icon entirely, custom: use custom icon */
          --dms-icon-svg-url: url('https://upload.wikimedia.org/wikipedia/commons/c/c4/Font_Awesome_5_solid_moon.svg'); /* icon svg url. MUST BE A SVG. */
          --dms-icon-svg-size: 90%; /* size of the svg (css mask-size property) */
          --dms-icon-color-before: var(--icon-subtle); /* normal icon color */
          --dms-icon-color-after: var(--white); /* icon color when button is hovered/selected */
          --custom-dms-background: image; /* off to disable, image to use a background image (must set url variable below), color to use a custom color/gradient */
          --dms-background-image-url: url('https://raw.githubusercontent.com/rose-pine/rose-pine-theme/main/assets/icon.png'); /* url of the background image */
          --dms-background-image-size: cover; /* size of the background image (css background-size property) */
          --dms-background-color: linear-gradient(70deg, var(--blue-2), var(--purple-2), var(--red-2)); /* fixed color/gradient (css background property) */

          /* background image options */
          --background-image: off; /* off: no background image, on: enable background image (must set url variable below) */
          --background-image-url: url('''); /* url of the background image */

          /* transparency/blur options */
          /* NOTE: TO USE TRANSPARENCY/BLUR, YOU MUST HAVE TRANSPARENT BG COLORS. FOR EXAMPLE: --bg-4: hsla(220, 15%, 10%, 0.7); */
          --transparency-tweaks: off; /* off: no changes, on: remove some elements for better transparency */
          --remove-bg-layer: off; /* off: no changes, on: remove the base --bg-3 layer for use with window transparency (WILL OVERRIDE BACKGROUND IMAGE) */
          --panel-blur: off; /* off: no changes, on: blur the background of panels */noi
          --blur-amount: 12px; /* amount of blur */
          --bg-floating: var(--bg-3); /* set this to a more opaque color if floating panels look too transparent. only applies if panel blur is on  */

          /* other options */
          --small-user-panel: on; /* off: default user panel, on: smaller user panel like in old discord */

          /* unrounding options */
          --unrounding: on; /* off: default, on: remove rounded corners from panels */

          /* styling options */
          --custom-spotify-bar: on; /* off: default, on: custom text-like spotify progress bar */
          --ascii-titles: on; /* off: default, on: use ascii font for titles at the start of a channel */
          --ascii-loader: system24; /* off: default, system24: use system24 ascii loader, cats: use cats loader */

          /* panel labels */
          --panel-labels: on; /* off: default, on: add labels to panels */
          --label-color: var(--text-muted); /* color of labels */
          --label-font-weight: 500; /* font weight of labels */
      }

      /* color options */
      :root {
          --colors: on; /* off: discord default colors, on: midnight custom colors */

          /* text colors */
          --text-0: var(--bg-2); /* text on colored elements */
          --text-1: hsl(245deg, 50%, 95%); /* other normally white text */
          --text-2: hsl(245deg, 50%, 91%); /* headings and important text */
          --text-3: hsl(246deg, 30%, 80%); /* normal text */
          --text-4: hsl(248deg, 15%, 61%); /* icon buttons and channels */
          --text-5: hsl(249deg, 12%, 47%); /* muted channels/chats and timestamps */

          /* background and dark colors */
          --bg-1: hsl(248deg, 21%, 32%); /* dark buttons when clicked */
          --bg-2: hsl(248deg, 21%, 26%); /* dark buttons */
          --bg-3: hsl(248deg, 24%, 20%); /* spacing, secondary elements */
          --bg-4: hsl(246deg, 24%, 17%); /* main background color */
          --hover: hsla(250deg, 20%, 45%, 0.1); /* channels and buttons when hovered */
          --active: hsla(250deg, 20%, 45%, 0.2); /* channels and buttons when clicked or selected */
          --active-2: hsla(250deg, 20%, 45%, 0.3); /* extra state for transparent buttons */
          --message-hover: hsla(250deg, 0%, 0%, 0.1); /* messages when hovered */

          /* accent colors */
          --accent-1: hsl(2deg, 66%, 80%); /* links and other accent text */
          --accent-2: hsl(2deg, 66%, 75%); /* small accent elements */
          --accent-3: hsl(2deg, 66%, 75%); /* accent buttons */
          --accent-4: hsl(2deg, 66%, 70%); /* accent buttons when hovered */
          --accent-5: hsl(2deg, 66%, 65%); /* accent buttons when clicked */
          --accent-new: var(--red-2); /* stuff that's normally red like mute/deafen buttons */
          --mention: linear-gradient(to right, color-mix(in hsl, var(--accent-2), transparent 90%) 40%, transparent); /* background of messages that mention you */
          --mention-hover: linear-gradient(to right, color-mix(in hsl, var(--accent-2), transparent 95%) 40%, transparent); /* background of messages that mention you when hovered */
          --reply: linear-gradient(to right, color-mix(in hsl, var(--text-3), transparent 90%) 40%, transparent); /* background of messages that reply to you */
          --reply-hover: linear-gradient(to right, color-mix(in hsl, var(--text-3), transparent 95%) 40%, transparent); /* background of messages that reply to you when hovered */

          /* status indicator colors */
          --online: var(--green-2); /* change to #43a25a for default */
          --dnd: var(--red-2); /* change to #d83a42 for default */
          --idle: var(--yellow-2); /* change to #ca9654 for default */
          --streaming: var(--purple-2); /* change to #593695 for default */
          --offline: var(--text-4); /* change to #83838b for default offline color */

          /* border colors */
          --border-light: var(--hover); /* general light border color */
          --border: var(--active); /* general normal border color */
          --border-hover: var(--accent-2); /* border color of panels when hovered */
          --button-border: hsl(250, 0%, 100%, 0.1); /* neutral border color of buttons */

          /* base colors */
          /* 2nd and 3rd colors are the default rose pine moon palette */
          --red-1: hsl(343deg, 76%, 73%);
          --red-2: hsl(343deg, 76%, 68%);
          --red-3: hsl(343deg, 76%, 68%);
          --red-4: hsl(343deg, 76%, 63%);
          --red-5: hsl(343deg, 76%, 58%);

          --green-1: hsl(197deg, 48%, 52%);
          --green-2: hsl(197deg, 48%, 47%);
          --green-3: hsl(197deg, 48%, 47%);
          --green-4: hsl(197deg, 48%, 42%);
          --green-5: hsl(197deg, 48%, 37%);

          --blue-1: hsl(189deg, 43%, 78%);
          --blue-2: hsl(189deg, 43%, 73%);
          --blue-3: hsl(189deg, 43%, 73%);
          --blue-4: hsl(189deg, 43%, 68%);
          --blue-5: hsl(189deg, 43%, 63%);

          --yellow-1: hsl(35deg, 88%, 77%);
          --yellow-2: hsl(35deg, 88%, 72%);
          --yellow-3: hsl(35deg, 88%, 72%);
          --yellow-4: hsl(35deg, 88%, 67%);
          --yellow-5: hsl(35deg, 88%, 62%);

          --purple-1: hsl(267deg, 57%, 83%);
          --purple-2: hsl(267deg, 57%, 78%);
          --purple-3: hsl(267deg, 57%, 78%);
          --purple-4: hsl(267deg, 57%, 73%);
          --purple-5: hsl(267deg, 57%, 68%);
      }
      '';
      xdg.configFile."Vencord/settings/settings.json".text = builtins.toJSON {
        notifyAboutUpdates = true;
        autoUpdate = false;
        autoUpdateNotification = false;
        useQuickCss = true;
        themeLinks = [ ];
        enabledThemes = [
          #"catppuccin-mocha.css"
          "system24-rose-pine.theme.css"
        ];
        enableReactDevtools = false;
        frameless = false;
        transparent = false;
        winCtrlQ = false;
        disableMinSize = false;
        winNativeTitleBar = false;
        plugins = {
          ChatInputButtonAPI.enabled = false;
          CommandsAPI.enabled = true;
          DynamicImageModalAPI.enabled = false;
          MemberListDecoratorsAPI.enabled = false;
          MessageAccessoriesAPI.enabled = true;
          MessageDecorationsAPI.enabled = false;
          MessageEventsAPI.enabled = false;
          MessagePopoverAPI.enabled = false;
          MessageUpdaterAPI.enabled = false;
          ServerListAPI.enabled = false;
          UserSettingsAPI.enabled = true;
          AccountPanelServerProfile.enabled = false;
          AlwaysAnimate.enabled = false;
          AlwaysExpandRoles.enabled = false;
          AlwaysTrust.enabled = true;
          AnonymiseFileNames.enabled = false;
          AppleMusicRichPresence.enabled = false;
          BANger.enabled = false;
          BetterFolders.enabled = false;
          BetterGifAltText.enabled = false;
          BetterGifPicker.enabled = false;
          BetterNotesBox.enabled = false;
          BetterRoleContext.enabled = false;
          BetterRoleDot.enabled = false;
          BetterSessions.enabled = false;
          BetterSettings.enabled = false;
          BetterUploadButton.enabled = false;
          BiggerStreamPreview.enabled = false;
          BlurNSFW.enabled = false;
          CallTimer.enabled = false;
          ClearURLs.enabled = true;
          ClientTheme.enabled = false;
          ColorSighted.enabled = false;
          ConsoleJanitor.enabled = false;
          ConsoleShortcuts.enabled = false;
          CopyEmojiMarkdown.enabled = false;
          CopyFileContents.enabled = true;
          CopyUserURLs.enabled = false;
          CrashHandler.enabled = true;
          CtrlEnterSend.enabled = false;
          CustomRPC.enabled = false;
          CustomIdle.enabled = false;
          Dearrow.enabled = false;
          Decor.enabled = false;
          DisableCallIdle.enabled = false;
          DontRoundMyTimestamps.enabled = false;
          EmoteCloner.enabled = true;
          Experiments.enabled = true;
          F8Break.enabled = false;
          FakeNitro.enabled = true;
          FakeProfileThemes.enabled = false;
          FavoriteEmojiFirst.enabled = false;
          FavoriteGifSearch.enabled = false;
          FixCodeblockGap.enabled = false;
          FixImagesQuality.enabled = false;
          FixSpotifyEmbeds.enabled = false;
          FixYoutubeEmbeds.enabled = false;
          ForceOwnerCrown.enabled = false;
          FriendInvites.enabled = false;
          FriendsSince.enabled = false;
          FullSearchContext.enabled = false;
          GameActivityToggle.enabled = false;
          GifPaste.enabled = false;
          GreetStickerPicker.enabled = false;
          HideAttachments.enabled = false;
          iLoveSpam.enabled = false;
          IgnoreActivities.enabled = false;
          ImageLink.enabled = false;
          ImageZoom.enabled = false;
          ImplicitRelationships.enabled = false;
          InvisibleChat.enabled = false;
          KeepCurrentChannel.enabled = false;
          LastFMRichPresence.enabled = false;
          LoadingQuotes.enabled = false;
          MemberCount.enabled = false;
          MentionAvatars.enabled = false;
          MessageClickActions.enabled = false;
          MessageLatency.enabled = false;
          MessageLinkEmbeds.enabled = false;
          # MessageLogger.enabled = false;
          MessageLogger = {
            enabled = true;
            logDeletes = true;
            collapseDeleted = false; # default: false
            logEdits = false; # default: true
            inlineEdits = false; # default: true
            ignoreBots = true; # default: false
            ignoreSelf = true; # default: false
          };
          MessageTags.enabled = false;
          MoreCommands.enabled = false;
          MoreKaomoji.enabled = false;
          MoreUserTags.enabled = false;
          Moyai.enabled = false;
          MutualGroupDMs.enabled = false;
          NewGuildSettings.enabled = false;
          NoBlockedMessages.enabled = false;
          NoDevtoolsWarning.enabled = false;
          NoF1.enabled = false;
          NoMaskedUrlPaste.enabled = false;
          NoMosaic.enabled = false;
          NoOnboardingDelay.enabled = false;
          NoPendingCount.enabled = false;
          NoProfileThemes.enabled = false;
          NoRPC.enabled = false;
          NoReplyMention.enabled = false;
          NoScreensharePreview.enabled = false;
          NoServerEmojis.enabled = false;
          NoSystemBadge.enabled = false;
          NoTypingAnimation.enabled = false;
          NoUnblockToJump.enabled = false;
          NormalizeMessageLinks.enabled = false;
          NotificationVolume.enabled = false;
          NSFWGateBypass.enabled = true;
          OnePingPerDM.enabled = false;
          oneko.enabled = false;
          OpenInApp.enabled = false;
          OverrideForumDefaults.enabled = false;
          PartyMode.enabled = false;
          PauseInvitesForever.enabled = false;
          PermissionFreeWill.enabled = false;
          PermissionsViewer.enabled = false;
          petpet.enabled = false;
          PictureInPicture.enabled = false;
          PinDMs.enabled = false;
          PlainFolderIcon.enabled = false;
          PlatformIndicators.enabled = false;
          PreviewMessage.enabled = false;
          QuickMention.enabled = false;
          QuickReply.enabled = false;
          ReactErrorDecoder.enabled = false;
          ReadAllNotificationsButton.enabled = false;
          RelationshipNotifier.enabled = false;
          ReplaceGoogleSearch = {
            enabled = true;
            customEngineName = "Startpage";
            customEngineURL = "https://www.startpage.com/sp/search?prfe=c602752472dd4a3d8286a7ce441403da08e5c4656092384ed3091a946a5a4a4c99962d0935b509f2866ff1fdeaa3c33a007d4d26e89149869f2f7d0bdfdb1b51aa7ae7f5f17ff4a233ff313d&query=";
          };
          ReplyTimestamp.enabled = false;
          RevealAllSpoilers.enabled = false;
          ReverseImageSearch.enabled = true;
          ReviewDB.enabled = false;
          RoleColorEverywhere.enabled = false;
          SecretRingToneEnabler.enabled = false;
          Summaries.enabled = false;
          SendTimestamps.enabled = false;
          ServerInfo.enabled = false;
          ServerListIndicators.enabled = false;
          ShikiCodeblocks.enabled = false;
          ShowAllMessageButtons.enabled = false;
          ShowConnections.enabled = false;
          ShowHiddenChannels = {
            enabled = false;
            hideUnreads = true;
            showMode = 1;
          };
          ShowHiddenThings.enabled = true;
          ShowMeYourName.enabled = false;
          ShowTimeoutDuration.enabled = false;
          SilentMessageToggle.enabled = false;
          SilentTyping = {
            enabled = true;
            showIcon = true;
            contextMenu = true;
            isEnabled = false; # Enable/Disable by default
          };
          SortFriendRequests.enabled = false;
          SpotifyControls.enabled = false;
          SpotifyCrack.enabled = true;
          SpotifyShareCommands.enabled = false;
          StartupTimings.enabled = false;
          StickerPaste.enabled = false;
          StreamerModeOnStream.enabled = false;
          SuperReactionTweaks.enabled = false;
          TextReplace.enabled = false;
          ThemeAttributes.enabled = false;
          Translate.enabled = false;
          TypingIndicator.enabled = false;
          TypingTweaks.enabled = false;
          Unindent.enabled = false;
          UnlockedAvatarZoom.enabled = false;
          UnsuppressEmbeds.enabled = false;
          UserMessagesPronouns.enabled = false;
          UserVoiceShow.enabled = false;
          USRBG.enabled = false;
          ValidReply.enabled = false;
          ValidUser.enabled = false;
          VoiceChatDoubleClick.enabled = false;
          VcNarrator.enabled = false;
          VencordToolbox.enabled = false;
          ViewIcons.enabled = false;
          ViewRaw.enabled = false;
          VoiceDownload.enabled = false;
          VoiceMessages.enabled = false;
          VolumeBooster.enabled = false;
          WhoReacted.enabled = false;
          XSOverlay.enabled = false;
          YoutubeAdblock.enabled = true;
          NoTrack.enabled = true;
          NoTrack.disableAnalytics = true;
          Settings.enabled = true;
          Settings.settingsLocation = "aboveNitro";
          SupportHelper.enabled = true;
        };
        notifications = {
          timeout = 5000;
          position = "bottom-right";
          useNative = "not-focused";
          logLimit = 50;
        };
        cloud = {
          authenticated = false;
          url = "https://api.vencord.dev/";
          settingsSync = false;
          settingsSyncVersion = 1737589382741;
        };
      };
    })
  ];
}
