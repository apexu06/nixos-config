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
      };
      version = 1;
    };

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
        position = "top_center";
        screenshotAnnotationTool = "";
        showCategories = true;
        showIconBackground = false;
        sortByMostUsed = true;
        terminalCommand = "xterm -e";
        useApp2Unit = false;
        viewMode = "list";
      };

      audio = {
        cavaFrameRate = 30;
        mprisBlacklist = [];
        preferredPlayer = "";
        visualizerType = "linear";
        volumeFeedback = false;
        volumeFeedbackSoundFile = "";
        volumeOverdrive = false;
        volumeStep = 5;
      };

      bar = {
        autoHideDelay = 500;
        autoShowDelay = 150;
        backgroundOpacity = 1.0; # Converted to float
        barType = "simple";
        capsuleColorKey = "none";
        capsuleOpacity = 1.0; # Converted to float
        contentPadding = 2;
        density = "comfortable";
        displayMode = "always_visible";
        floating = false;
        fontScale = 1.0; # Converted to float
        frameRadius = 12;
        frameThickness = 8;
        hideOnOverview = true;
        marginHorizontal = 5;
        marginVertical = 5;
        monitors = [];
        outerCorners = true;
        position = "top";
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
              compactMode = false;
              compactShowAlbumArt = true;
              compactShowVisualizer = false;
              hideMode = "hidden";
              hideWhenIdle = false;
              id = "MediaMini";
              maxWidth = 300;
              panelShowAlbumArt = true;
              panelShowVisualizer = true;
              scrollingMode = "hover";
              showAlbumArt = true;
              showArtistFirst = true;
              showProgressRing = true;
              showVisualizer = true;
              textColor = "none";
              useFixedWidth = false;
              visualizerType = "linear";
            }
          ];
          left = [
            {
              characterCount = 2;
              colorizeIcons = false;
              emptyColor = "secondary";
              enableScrollWheel = true;
              focusedColor = "primary";
              followFocusedScreen = false;
              groupedBorderOpacity = 1.0; # Converted to float
              hideUnoccupied = false;
              iconScale = 0.8;
              id = "Workspace";
              labelMode = "index";
              occupiedColor = "secondary";
              pillSize = 0.6;
              showApplications = false;
              showBadge = true;
              showLabelsOnlyWhenOccupied = true;
              unfocusedIconsOpacity = 1.0; # Converted to float
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
              displayMode = "alwaysShow";
              iconColor = "none";
              id = "Volume";
              middleClickCommand = "pwvucontrol || pavucontrol";
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

      brightness = {
        backlightDeviceMappings = [];
        brightnessStep = 5;
        enableDdcSupport = true;
        enforceMinimum = true;
      };

      calendar = {
        cards = [
          {
            enabled = true;
            id = "calendar-header-card";
          }
          {
            enabled = true;
            id = "calendar-month-card";
          }
          {
            enabled = true;
            id = "weather-card";
          }
        ];
      };

      colorSchemes = {
        darkMode = true;
        generationMethod = "tonal-spot";
        manualSunrise = "06:30";
        manualSunset = "18:30";
        monitorForColors = "";
        predefinedScheme = "Noctalia (default)";
        schedulingMode = "off";
        useWallpaperColors = false;
      };

      controlCenter = {
        cards = [
          {
            enabled = true;
            id = "profile-card";
          }
          {
            enabled = true;
            id = "shortcuts-card";
          }
          {
            enabled = true;
            id = "audio-card";
          }
          {
            enabled = false;
            id = "brightness-card";
          }
          {
            enabled = true;
            id = "weather-card";
          }
          {
            enabled = true;
            id = "media-sysmon-card";
          }
        ];
        diskPath = "/";
        position = "close_to_bar_button";
        shortcuts = {
          left = [
            {id = "Network";}
            {id = "Bluetooth";}
            {id = "WallpaperSelector";}
            {
              id = "plugin:screen-recorder";
              defaultSettings = {
                audioCodec = "opus";
                audioSource = "default_output";
                colorRange = "limited";
                copyToClipboard = false;
                directory = "";
                filenamePattern = "recording_yyyyMMdd_HHmmss";
                frameRate = "60";
                hideInactive = false;
                iconColor = "none";
                quality = "very_high";
                resolution = "original";
                showCursor = true;
                videoCodec = "h264";
                videoSource = "portal";
              };
            }
          ];
          right = [
            {id = "Notifications";}
            {id = "PowerProfile";}
            {id = "KeepAwake";}
            {id = "NightLight";}
          ];
        };
      };

      desktopWidgets = {
        enabled = false;
        gridSnap = false;
        monitorWidgets = [];
        overviewEnabled = true;
      };

      dock = {
        animationSpeed = 1.0;
        backgroundOpacity = 1.0;
        colorizeIcons = false;
        deadOpacity = 0.6;
        displayMode = "auto_hide";
        dockType = "floating";
        enabled = true;
        floatingRatio = 1.0;
        groupApps = false;
        groupClickAction = "cycle";
        groupContextMenuMode = "extended";
        groupIndicatorStyle = "dots";
        inactiveIndicators = false;
        launcherIconColor = "none";
        launcherPosition = "end";
        monitors = [];
        onlySameOutput = true;
        pinnedApps = [];
        pinnedStatic = false;
        position = "bottom";
        showFrameIndicator = true;
        showLauncherIcon = false;
        sitOnFrame = false;
        size = 1.0;
      };

      general = {
        allowPanelsOnScreenWithoutBar = true;
        allowPasswordWithFprintd = true;
        animationDisabled = false;
        animationSpeed = 1.0;
        autoStartAuth = true;
        avatarImage = "/home/apexu/.face";
        boxRadiusRatio = 1.0;
        clockFormat = "hh\\nmm";
        clockStyle = "custom";
        compactLockScreen = false;
        dimmerOpacity = 0.2;
        enableLockScreenCountdown = true;
        enableLockScreenMediaControls = true;
        enableShadows = true;
        forceBlackScreenCorners = false;
        iRadiusRatio = 1.0;
        keybinds = {
          keyDown = ["Ctrl+N"];
          keyEnter = ["Return"];
          keyEscape = ["Esc"];
          keyLeft = ["Left"];
          keyRemove = ["Del"];
          keyRight = ["Right"];
          keyUp = ["Ctrl+P"];
        };
        language = "";
        lockOnSuspend = true;
        lockScreenAnimations = true;
        lockScreenBlur = 0.0;
        lockScreenCountdownDuration = 10000;
        lockScreenMonitors = [];
        lockScreenTint = 0.0;
        passwordChars = false;
        radiusRatio = 1.0;
        reverseScroll = false;
        scaleRatio = 1.0;
        screenRadiusRatio = 1.0;
        shadowDirection = "center";
        shadowOffsetX = 0.0;
        shadowOffsetY = 0.0;
        showChangelogOnStartup = true;
        showHibernateOnLockScreen = false;
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
        lockTimeout = 300;
        screenOffTimeout = 330;
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
        showWeekNumberInCalendar = false;
        use12hourFormat = false;
        useFahrenheit = false;
        weatherEnabled = true;
        weatherShowEffects = true;
      };

      network = {
        airplaneModeEnabled = false;
        bluetoothDetailsViewMode = "grid";
        bluetoothHideUnnamedDevices = false;
        bluetoothRssiPollIntervalMs = 10000;
        bluetoothRssiPollingEnabled = false;
        disableDiscoverability = false;
        networkPanelView = "wifi";
        wifiDetailsViewMode = "grid";
        wifiEnabled = false;
      };

      nightLight = {
        autoSchedule = true;
        dayTemp = "6500";
        enabled = true;
        forced = false;
        manualSunrise = "08:00";
        manualSunset = "15:00";
        nightTemp = "4000";
      };

      notifications = {
        backgroundOpacity = 1.0;
        clearDismissed = true;
        criticalUrgencyDuration = 15;
        density = "default";
        enableBatteryToast = true;
        enableKeyboardLayoutToast = true;
        enableMarkdown = false;
        enableMediaToast = false;
        enabled = true;
        location = "top_center";
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
        backgroundOpacity = 1.0;
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
            keybind = "";
          }
        ];
        showHeader = true;
        showKeybinds = true;
      };

      settingsVersion = 53;

      systemMonitor = {
        batteryCriticalThreshold = 5;
        batteryWarningThreshold = 20;
        cpuCriticalThreshold = 90;
        cpuWarningThreshold = 80;
        criticalColor = "";
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
        warningColor = "";
      };

      templates = {
        activeTemplates = [];
        enableUserTheming = false;
      };

      ui = {
        boxBorderEnabled = true;
        fontDefault = "Adwaita Sans";
        fontDefaultScale = 1.05;
        fontFixed = "Adwaita Mono";
        fontFixedScale = 1.0;
        panelBackgroundOpacity = 1.0;
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
