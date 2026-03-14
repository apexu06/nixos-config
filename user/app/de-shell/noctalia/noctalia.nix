{
  lib,
  pkgs,
  inputs,
  settings,
  ...
}: let
  noctalia = cmd:
    [
      "noctalia-shell"
      "ipc"
      "call"
    ]
    ++ (pkgs.lib.splitString " " cmd);
in {
  home.packages = with pkgs; [
    gpu-screen-recorder
    adwaita-icon-theme
  ];

  imports = [
    inputs.noctalia.homeModules.default
  ];

  home.file.".config/noctalia/pam/password.conf".text = ''
    auth sufficient pam_fprintd.so max-tries=1
    auth required pam_unix.so
  '';

  programs.noctalia-shell = {
    enable = true;
    package = inputs.noctalia.packages.${pkgs.system}.default.override {
      calendarSupport = true;
    };

    plugins = {
      sources = [
        {
          enabled = true;
          name = "Official Noctalia Plugins";
          url = "https://github.com/noctalia-dev/noctalia-plugins";
        }
      ];
      states = {
        pomodoro = {
          enabled = true;
          sourceUrl = "https://github.com/noctalia-dev/noctalia-plugins";
        };
        screen-recorder = {
          enabled = true;
          sourceUrl = "https://github.com/noctalia-dev/noctalia-plugins";
        };
        battery-actions = {
          enabled = true;
          sourceUrl = "https://github.com/noctalia-dev/noctalia-plugins";
        };
        privacy-indicator = {
          enabled = true;
          sourceUrl = "https://github.com/noctalia-dev/noctalia-plugins";
        };
      };
      version = 1;
    };

    # Noctalia NixOS Configuration
    # Settings Version: 57
    settings = {
      appLauncher = {
        autoPasteClipboard = false;
        clipboardWatchImageCommand = "wl-paste --type image --watch cliphist store";
        clipboardWatchTextCommand = "wl-paste --type text --watch cliphist store";
        clipboardWrapText = true;
        customLaunchPrefix = "";
        customLaunchPrefixEnabled = false;
        density = "default";
        enableClipPreview = true;
        enableClipboardHistory = false;
        enableSessionSearch = false;
        enableSettingsSearch = false;
        enableWindowsSearch = true;
        iconMode = "tabler";
        ignoreMouseInput = false;
        overviewLayer = false;
        pinnedApps = [
          "zen-twilight"
          "spotify"
          "discord"
          "firefox"
        ];
        position = "follow_bar"; # [cite: 1]
        screenshotAnnotationTool = "";
        showCategories = true;
        showIconBackground = false;
        sortByMostUsed = true;
        terminalCommand = "xterm -e";
        useApp2Unit = false;
        viewMode = "list";
      };

      audio = {
        mprisBlacklist = [];
        preferredPlayer = "";
        spectrumFrameRate = 30;
        visualizerType = "linear";
        volumeFeedback = false;
        volumeFeedbackSoundFile = "";
        volumeOverdrive = false;
        volumeStep = 5;
      };

      bar = {
        autoHideDelay = 500;
        autoShowDelay = 150;
        backgroundOpacity = 1.0; # [cite: 1]
        barType = "simple";
        capsuleColorKey = "none";
        capsuleOpacity = 1.0; # [cite: 1]
        contentPadding = 2;
        density = "comfortable";
        displayMode = "always_visible";
        floating = false;
        fontScale = 1.0; # [cite: 1]
        frameRadius = 12;
        frameThickness = 8;
        hideOnOverview = true;
        marginHorizontal = 5;
        marginVertical = 5;
        middleClickAction = "settings"; # [cite: 2]
        middleClickCommand = "";
        middleClickFollowMouse = true; # [cite: 2]
        monitors = [];
        mouseWheelAction = "workspace"; # [cite: 2]
        mouseWheelWrap = true;
        outerCorners = true;
        position = "left"; # [cite: 2]
        reverseScroll = false;
        rightClickAction = "controlCenter";
        rightClickCommand = "";
        rightClickFollowMouse = true;
        screenOverrides = [];
        showCapsule = true;
        showOnWorkspaceSwitch = true;
        showOutline = false;
        useSeparateOpacity = false;
        widgetSpacing = 6;
        widgets = {
          center = [
            {
              clockColor = "none";
              customFont = "";
              formatHorizontal = "HH:mm ddd, MMM dd";
              formatVertical = "HH mm - dd MM";
              id = "Clock";
              tooltipFormat = "HH:mm ddd, MMM dd";
              useCustomFont = false;
            }
            {
              compactMode = false; # [cite: 3]
              hideMode = "hidden";
              hideWhenIdle = false;
              id = "MediaMini";
              maxWidth = 300;
              panelShowAlbumArt = true;
              scrollingMode = "hover";
              showAlbumArt = true;
              showArtistFirst = true;
              showProgressRing = true;
              showVisualizer = false; # [cite: 3]
              textColor = "none";
              useFixedWidth = false;
              visualizerType = "linear";
            }
            # Privacy Indicator plugin removed based on diff [cite: 4, 5, 9]
          ];
          left = [
            {
              characterCount = 2;
              colorizeIcons = false;
              emptyColor = "secondary";
              enableScrollWheel = true;
              focusedColor = "primary";
              followFocusedScreen = false;
              fontWeight = "bold";
              groupedBorderOpacity = 1.0; # [cite: 6]
              hideUnoccupied = false;
              iconScale = 0.8;
              id = "Workspace";
              labelMode = "index";
              occupiedColor = "secondary";
              pillSize = 0.6;
              showApplications = false;
              showBadge = true;
              showLabelsOnlyWhenOccupied = true;
              unfocusedIconsOpacity = 1.0; # [cite: 7]
            }
            {
              colorizeIcons = false;
              hideMode = "hidden";
              id = "ActiveWindow";
              maxWidth = 145;
              scrollingMode = "hover";
              showIcon = true;
              textColor = "none";
              useFixedWidth = false;
            }
          ];
          right = [
            {
              id = "plugin:pomodoro";
              defaultSettings = {
                autoStartBreaks = false;
                autoStartWork = false;
                longBreakDuration = 15;
                sessionsBeforeLongBreak = 4;
                shortBreakDuration = 5;
                workDuration = 25;
              };
            }
            {
              hideWhenZero = false;
              hideWhenZeroUnread = false;
              iconColor = "none";
              id = "NotificationHistory";
              showUnreadBadge = true;
              unreadBadgeColor = "primary";
            }
            {
              displayMode = "alwaysShow";
              iconColor = "none";
              id = "Network";
              textColor = "none";
            }
            {
              displayMode = "onhover"; # [cite: 8]
              iconColor = "none";
              id = "Volume";
              middleClickCommand = "pwvucontrol || pavucontrol"; # [cite: 8, 9]
              textColor = "none";
            }
            {
              displayMode = "onhover";
              iconColor = "none";
              id = "Bluetooth";
              textColor = "none";
            }
            {
              deviceNativePath = "__default__";
              displayMode = "onhover";
              hideIfIdle = false;
              hideIfNotDetected = true;
              id = "Battery";
              showNoctaliaPerformance = false;
              showPowerProfiles = true;
            }
            {
              applyToAllMonitors = false;
              displayMode = "onhover";
              iconColor = "none";
              id = "Brightness";
              textColor = "none";
            }
            {
              blacklist = ["blueman-applet" "udiskie" "blueman-tray"];
              chevronColor = "none";
              colorizeIcons = false;
              drawerEnabled = false;
              hidePassive = false;
              id = "Tray";
              pinned = [];
            }
            {
              colorizeDistroLogo = false;
              colorizeSystemIcon = "primary";
              customIconPath = "";
              enableColorization = true;
              icon = "noctalia";
              id = "ControlCenter";
              useDistroLogo = true;
            }
          ];
        };
      };

      desktopWidgets = {
        enabled = true;
        gridSnap = true;
        monitorWidgets = [
          {
            name = "DP-3";
            widgets = [];
          }
          {
            name = "HDMI-A-1";
            widgets = [
              {
                hideMode = "visible";
                id = "MediaPlayer";
                roundedCorners = true;
                scale = 1.0; # [cite: 10]
                showAlbumArt = true;
                showBackground = true;
                showButtons = true; # [cite: 11]
                showVisualizer = true;
                visualizerType = "linear";
                x = 1440; # [cite: 11]
                y = 100; # [cite: 11]
              }
              {
                id = "Weather";
                roundedCorners = true;
                scale = 1.0; # [cite: 12]
                showBackground = false;
                x = 1600;
                y = 900;
              }
              {
                clockColor = "none";
                clockStyle = "analog";
                customFont = "";
                format = "HH:mm\\nd MMMM yyyy";
                id = "Clock";
                roundedCorners = true;
                scale = 1.0; # [cite: 13]
                showBackground = false;
                useCustomFont = false;
                x = 1680; # [cite: 14]
                y = 700;
              }
            ];
          }
        ];
        overviewEnabled = true;
      };

      dock = {
        animationSpeed = 1.0; # [cite: 14]
        backgroundOpacity = 1.0; # [cite: 14]
        colorizeIcons = false;
        deadOpacity = 0.6;
        displayMode = "auto_hide";
        dockType = "floating";
        enabled = false; # [cite: 14]
        floatingRatio = 1.0; # [cite: 14]
        groupApps = false;
        groupClickAction = "cycle"; # [cite: 15]
        groupContextMenuMode = "extended";
        groupIndicatorStyle = "dots";
        inactiveIndicators = false;
        indicatorColor = "primary";
        indicatorOpacity = 0.6;
        indicatorThickness = 3;
        launcherIconColor = "none";
        launcherPosition = "end";
        monitors = [];
        onlySameOutput = true;
        pinnedApps = [];
        pinnedStatic = false;
        position = "bottom";
        showDockIndicator = false;
        showLauncherIcon = false;
        sitOnFrame = false;
        size = 1.0; # [cite: 15]
      };

      general = {
        allowPanelsOnScreenWithoutBar = true;
        allowPasswordWithFprintd = true;
        animationDisabled = false;
        animationSpeed = 1.3; # [cite: 15]
        autoStartAuth = false;
        avatarImage = "/home/apexu/.face";
        boxRadiusRatio = 1.0; # [cite: 15]
        clockFormat = "hh\\nmm"; # [cite: 16]
        clockStyle = "custom";
        compactLockScreen = false;
        dimmerOpacity = 0.2;
        enableBlurBehind = true;
        enableLockScreenCountdown = true;
        enableLockScreenMediaControls = false;
        enableShadows = true;
        forceBlackScreenCorners = false;
        iRadiusRatio = 1.0; # [cite: 16]
        keybinds = {
          keyDown = ["Ctrl+N"];
          keyEnter = ["Return" "Enter"];
          keyEscape = ["Esc"];
          keyLeft = ["Left"];
          keyRemove = ["Del"];
          keyRight = ["Right"];
          keyUp = ["Ctrl+P"];
        };
        language = "";
        lockOnSuspend = true;
        lockScreenAnimations = false;
        lockScreenBlur = 0.0; # [cite: 17]
        lockScreenCountdownDuration = 10000;
        lockScreenMonitors = [];
        lockScreenTint = 0.0; # [cite: 17]
        passwordChars = false;
        radiusRatio = 1.0; # [cite: 17]
        reverseScroll = false;
        scaleRatio = 1.0; # [cite: 17]
        screenRadiusRatio = 1.0; # [cite: 17]
        shadowDirection = "center";
        shadowOffsetX = 0.0; # [cite: 17]
        shadowOffsetY = 0.0; # [cite: 17]
        showChangelogOnStartup = true;
        showHibernateOnLockScreen = false; # [cite: 18]
        showScreenCorners = true;
        showSessionButtonsOnLockScreen = false;
        telemetryEnabled = false;
      };

      hooks = {
        darkModeChange = "";
        enabled = false;
        performanceModeDisabled = "";
        performanceModeEnabled = "";
        screenLock = "";
        screenUnlock = "";
        session = "";
        startup = "";
        wallpaperChange = "";
      };

      idle = {
        customCommands = "[{\"timeout\":150,\"command\":\"brightnessctl -s set 10\"}]";
        enabled = true;
        fadeDuration = 5;
        lockCommand = "";
        lockTimeout = 300;
        resumeLockCommand = "";
        resumeScreenOffCommand = "";
        resumeSuspendCommand = "";
        screenOffCommand = "";
        screenOffTimeout = 330;
        suspendCommand = "";
        suspendTimeout = 1800;
      };

      location = {
        analogClockInCalendar = false;
        firstDayOfWeek = -1;
        hideWeatherCityName = false;
        hideWeatherTimezone = false;
        name = "Straden";
        showCalendarEvents = true;
        showCalendarWeather = true;
        showWeekNumberInCalendar = true; # [cite: 18]
        use12hourFormat = false;
        useFahrenheit = false;
        weatherEnabled = true;
        weatherShowEffects = true;
      };

      network = {
        airplaneModeEnabled = false;
        bluetoothAutoConnect = true;
        bluetoothDetailsViewMode = "grid";
        bluetoothHideUnnamedDevices = false;
        bluetoothRssiPollIntervalMs = 10000;
        bluetoothRssiPollingEnabled = false;
        disableDiscoverability = false;
        networkPanelView = "wifi";
        wifiDetailsViewMode = "grid";
        wifiEnabled = false; # [cite: 18]
      };

      nightLight = {
        autoSchedule = true; # [cite: 19]
        dayTemp = "6500";
        enabled = true;
        forced = false;
        manualSunrise = "08:00";
        manualSunset = "15:00";
        nightTemp = "4000";
      };

      noctaliaPerformance = {
        disableDesktopWidgets = true;
        disableWallpaper = true;
      };

      notifications = {
        backgroundOpacity = 1.0; # [cite: 19]
        clearDismissed = true;
        criticalUrgencyDuration = 15;
        density = "default";
        enableBatteryToast = true;
        enableKeyboardLayoutToast = true;
        enableMarkdown = false;
        enableMediaToast = false;
        enabled = true;
        location = "top";
        lowUrgencyDuration = 3;
        monitors = [];
        normalUrgencyDuration = 8;
        overlayLayer = true;
        respectExpireTimeout = false;
        saveToHistory = {
          critical = true;
          low = true;
          normal = true;
        };
        sounds = {
          criticalSoundFile = "";
          enabled = false;
          excludedApps = "discord,firefox,chrome,chromium,edge";
          lowSoundFile = "";
          normalSoundFile = "";
          separateSounds = false;
          volume = 0.5;
        };
      };

      osd = {
        autoHideMs = 2000;
        backgroundOpacity = 1.0; # [cite: 19]
        enabled = true;
        enabledTypes = [0 1 2];
        location = "bottom";
        monitors = [];
        overlayLayer = true;
      };

      plugins = {
        autoUpdate = false;
      };

      sessionMenu = {
        countdownDuration = 10000;
        enableCountdown = true;
        largeButtonsLayout = "grid";
        largeButtonsStyle = true;
        position = "center";
        powerOptions = [
          {
            action = "lock";
            command = "";
            countdownEnabled = true;
            enabled = true;
            keybind = "1";
          }
          {
            action = "suspend";
            command = "";
            countdownEnabled = true;
            enabled = true;
            keybind = "2";
          }
          {
            action = "hibernate";
            command = "";
            countdownEnabled = true;
            enabled = true;
            keybind = "3";
          }
          {
            action = "reboot";
            command = "";
            countdownEnabled = true;
            enabled = true;
            keybind = "4";
          }
          {
            action = "logout";
            command = "";
            countdownEnabled = true;
            enabled = true;
            keybind = "5";
          }
          {
            action = "shutdown";
            command = "";
            countdownEnabled = true;
            enabled = true;
            keybind = "6";
          }
          {
            action = "rebootToUefi";
            command = "";
            countdownEnabled = true;
            enabled = true;
            keybind = "7";
          }
          {
            action = "userspaceReboot";
            command = "";
            countdownEnabled = true;
            enabled = false;
            keybind = "";
          }
        ];
        showHeader = true;
        showKeybinds = true;
      };

      settingsVersion = 57;

      systemMonitor = {
        batteryCriticalThreshold = 5;
        batteryWarningThreshold = 20; # [cite: 20]
        cpuCriticalThreshold = 90;
        cpuWarningThreshold = 80;
        criticalColor = "#f7768e"; # [cite: 20]
        diskAvailCriticalThreshold = 10;
        diskAvailWarningThreshold = 20;
        diskCriticalThreshold = 90;
        diskWarningThreshold = 80;
        enableDgpuMonitoring = false;
        externalMonitor = "resources || missioncenter || jdsystemmonitor || corestats || system-monitoring-center || gnome-system-monitor || plasma-systemmonitor || mate-system-monitor || ukui-system-monitor || deepin-system-monitor || pantheon-system-monitor";
        gpuCriticalThreshold = 90;
        gpuWarningThreshold = 80;
        memCriticalThreshold = 90;
        memWarningThreshold = 80;
        swapCriticalThreshold = 90;
        swapWarningThreshold = 80;
        tempCriticalThreshold = 90;
        tempWarningThreshold = 80;
        useCustomColors = false;
        warningColor = "#7dcfff"; # [cite: 20]
      };

      templates = {
        activeTemplates = [];
        enableUserTheming = false;
      };

      ui = {
        boxBorderEnabled = false; # [cite: 21]
        fontDefault = "Adwaita Sans";
        fontDefaultScale = 1.05;
        fontFixed = "Adwaita Mono";
        fontFixedScale = 1.0; # [cite: 21]
        panelBackgroundOpacity = 1.0; # [cite: 21]
        panelsAttachedToBar = true;
        settingsPanelMode = "attached";
        settingsPanelSideBarCardStyle = false;
        tooltipsEnabled = true;
      };

      wallpaper = {
        automationEnabled = false;
        directory = "/home/apexu/Pictures/Wallpapers";
        enableMultiMonitorDirectories = false;
        enabled = true;
        favorites = [];
        fillColor = "#000000";
        fillMode = "crop";
        hideWallpaperFilenames = false;
        monitorDirectories = [];
        overviewBlur = 0.4;
        overviewEnabled = false;
        overviewTint = 0.6;
        panelPosition = "follow_bar";
        randomIntervalSec = 300;
        setWallpaperOnAllMonitors = true;
        showHiddenFiles = false;
        skipStartupTransition = true;
        solidColor = "#1a1a2e";
        sortOrder = "name";
        transitionDuration = 1500;
        transitionEdgeSmoothness = 0.05;
        transitionType = "random";
        useSolidColor = false;
        useWallhaven = false;
        viewMode = "single";
        wallhavenApiKey = "";
        wallhavenCategories = "111";
        wallhavenOrder = "desc";
        wallhavenPurity = "100";
        wallhavenQuery = "";
        wallhavenRatios = "";
        wallhavenResolutionHeight = "";
        wallhavenResolutionMode = "atleast";
        wallhavenResolutionWidth = "";
        wallhavenSorting = "relevance";
        wallpaperChangeMode = "random";
      };
    };
  };

  services.hyprpaper.enable = lib.mkForce settings.useWallpaper;

  services.hypridle.settings = {
    general = {
      lock_cmd = lib.mkForce "pidof qs || noctalia-shell ipc call lockScreen lock";
      before_sleep_cmd = lib.mkForce "noctalia-shell ipc call lockScreen lock";
      after_sleep_cmd = lib.mkForce "niri msg action power-on-monitors";
    };

    listener = [
      {
        timeout = 300; # 5min
        on-timeout = lib.mkForce "noctalia-shell ipc call lockScreen lock";
      }
      {
        timeout = 330; # 5.5min
        on-timeout = lib.mkForce "niri msg action power-off-monitors"; # screen off when timeout has passed
        on-resume = lib.mkForce "niri msg action power-on-monitors";
      }
    ];
  };

  programs.niri.settings = {
    layer-rules = [
      {
        matches = [
          {namespace = "^noctalia-wallpaper*";}
        ];
        place-within-backdrop = true;
      }
    ];
    binds = {
      "Mod+Alt+L".action =
        lib.mkForce {spawn = noctalia "lockScreen lock";};

      "Mod+P".action =
        lib.mkForce {spawn = noctalia "launcher toggle";};

      "Mod+Shift+M".action =
        lib.mkForce {spawn = noctalia "sessionMenu toggle";};

      "Mod+Shift+W".action =
        lib.mkForce {spawn = noctalia "wallpaper toggle";};
    };
  };
}
