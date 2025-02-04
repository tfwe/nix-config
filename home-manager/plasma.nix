{
  programs.plasma = {
    enable = true;
    overrideConfig = true;
    fonts = {
      general = {
        family = "Roboto";
        pointSize = 12;
      };
      toolbar = {
        family = "Roboto";
        pointSize = 10;
      };
      windowTitle = {
        family = "Roboto";
        pointSize = 10;
      };
      menu = {
        family = "Roboto";
        pointSize = 10;
      };
      fixedWidth = {
        family = "agave Nerd Font Mono";
        pointSize = 13;
      };
    };
    workspace = {
      clickItemTo = "select";
      iconTheme = "Numix-Circle";
      colorScheme = "Sweet";
      splashScreen.theme = "QuarksSplashDarker";
      theme = "Aritim-Dark-Flat-Blur";
      windowDecorations = {
        library = "org.kde.kwin.aurorae";
        theme = "__aurorae__svg__Sweet-Dark";
      };
      wallpaperBackground.blur = true;
    };
    panels = [
      {
        location = "bottom";
        height = 52;
      }
    ];
    desktop = {
      icons = {
        size = 3;
      };
      widgets = [
        {
          systemMonitor = {
            position = {
              horizontal = 1888;
              vertical = 800;
            };
            size = {
              width = 592;
              height = 288;
            };
            title = "Network speed";
            displayStyle = "org.kde.ksysguard.linechart";
            sensors = [
              {
                name = "network/all/download";
                color = "197,14,210";
                label = "Down";
              }
              {
                name = "network/all/upload";
                color = "27,210,14";
                label = "Up";
              }
            ];

          };
        }
        {
          systemMonitor = {
            position = {
              horizontal = 1440;
              vertical = 352;
            };
            size = {
              width = 1040;
              height = 432;
            };
                        title = "CPU Usage";
            displayStyle = "org.kde.ksysguard.linechart";
            sensors = [
              {
                name = "cpu/cpu0/usage";
                color = "197,14,210";
                label = "Core 1 (P)";
              }
              {
                name = "cpu/cpu1/usage";
                color = "210,14,150";
                label = "Core 2 (P)";
              }
              {
                name = "cpu/cpu2/usage";
                color = "210,14,76";
                label = "Core 3 (P)";
              }
              {
                name = "cpu/cpu3/usage";
                color = "210,25,14";
                label = "Core 4 (P)";
              }
              {
                name = "cpu/cpu4/usage";
                color = "210,99,14";
                label = "Core 5 (P)";
              }
              {
                name = "cpu/cpu5/usage";
                color = "210,172,14";
                label = "Core 6 (P)";
              }
              {
                name = "cpu/cpu6/usage";
                color = "174,210,14";
                label = "Core 7 (P)";
              }
              {
                name = "cpu/cpu7/usage";
                color = "101,210,14";
                label = "Core 8 (P)";
              }
              {
                name = "cpu/cpu8/usage";
                color = "27,210,14";
                label = "Core 9 (P)";
              }
              {
                name = "cpu/cpu9/usage";
                color = "14,210,74";
                label = "Core 10 (P)";
              }
              {
                name = "cpu/cpu10/usage";
                color = "14,210,148";
                label = "Core 11 (P)";
              }
              {
                name = "cpu/cpu11/usage";
                color = "14,199,210";
                label = "Core 12 (P)";
              }
              {
                name = "cpu/cpu12/usage";
                color = "14,125,210";
                label = "Core 13 (E)";
              }
              {
                name = "cpu/cpu13/usage";
                color = "14,52,210";
                label = "Core 14 (E)";
              }
              {
                name = "cpu/cpu14/usage";
                color = "50,14,210";
                label = "Core 15 (E)";
              }
              {
                name = "cpu/cpu15/usage";
                color = "123,14,210";
                label = "Core 16 (E)";
              }
            ];
            textOnlySensors = ["cpu/all/averageTemperature" "cpu/all/maximumTemperature" "cpu/all/averageFrequency" "cpu/all/usage" "os/system/uptime"];

          };
        }
        {
          systemMonitor = {
            position = {
              horizontal = 1440;
              vertical = 16;
            };
            size = {
              width = 544;
              height = 320;
            };
            title = "Disk Usage";
            displayStyle = "org.kde.ksysguard.horizontalbars";
            sensors = [
              {
                name = "disk/all/usedPercent";
                color = "14,210,197";
                label = "Total System Used";
              }
              {
                name = "disk/(?!all).*/used";
                color = "82,14,210";
                label = "Disk Usage";
              }
            ];
            textOnlySensors = ["disk/all/total" "disk/all/free" "lmsensors/nvme-pci-0200/temp1" "lmsensors/nvme-pci-0400/temp1"];
          };
        }
        {
          systemMonitor = {
            position = {
              horizontal = 2000;
              vertical = 16;
            };
            size = {
              width = 480;
              height = 320;
            };
            title = "Memory Usage";
            displayStyle = "org.kde.ksysguard.horizontalbars";
            sensors = [
              {
                name = "memory/physical/usedPercent";
                color = "125,14,210";
                label = "Physical";
              }
              {
                name = "memory/swap/usedPercent";
                color = "210,49,14";
                label = "Swap";
              }
            ];
            textOnlySensors = ["memory/physical/total" "memory/swap/total"];
          };
        }
        {
          systemMonitor = {
            position = {
              horizontal = 1440;
              vertical = 800;
            };
            size = {
              width = 432;
              height = 288;
            };
            title = "GPU Usage";
            displayStyle = "org.kde.ksysguard.linechart";
            sensors = [
              {
                name = "gpu/gpu1/usage";
                color = "143,14,210";
                label = "Total Usage";
              }
              {
                name = "gpu/gpu1/temperature";
                color = "114,14,210";
                label = "Temp";
              }
            ];
            textOnlySensors = ["gpu/gpu1/usedVram" "gpu/gpu1/totalVram"];
          };
        }
      ];
    };
    startup.startupScript = {
      restartkde.text = "";
      restartkde.restartServices = ["plasma-plasmashell"];
    };

    session = {
      sessionRestore.restoreOpenApplicationsOnLogin = "startWithEmptySession";
    };
    spectacle.shortcuts = {
      captureActiveWindow = "Meta+Print";
      captureCurrentMonitor = "Shift+Print";
      captureRectangularRegion = "Meta+Shift+Print";
      captureWindowUnderCursor = "Meta+Ctrl+Print";
    };
    powerdevil.AC ={
      autoSuspend.action = "nothing";
      powerProfile = "performance";
      turnOffDisplay.idleTimeout = "never";
    };
    kwin = {
      nightLight = {
        enable = true;
        mode = "location";
        location = {
          latitude = "45.416199823401364";
          longitude = "-75.71475572367211";
        };
        temperature = {
          day = 4500;
          night = 2100;
        };
        transitionTime = 30;
      };
      effects = {
        dimInactive.enable = true;
        blur.enable = false;
        wobblyWindows.enable = true;
        translucency.enable = true;
      };
      virtualDesktops = {
        number = 2;
        rows = 1;
        names = ["L" "R"];
      };
    };
    shortcuts = {
      "kmix"."decrease_volume" = "Meta+Alt+Down";
      "kmix"."increase_volume" = "Meta+Alt+Up";
      "ksmserver"."Log Out" = "Ctrl+Alt+Del";
      "kwin"."Overview" = "Meta+W";
      "kwin"."Switch One Desktop to the Left" = "Meta+Ctrl+Left";
      "kwin"."Switch One Desktop to the Right" = "Meta+Ctrl+Right";
      "kwin"."Window Close" = "Alt+F4";
      "kwin"."Window Maximize" = "Meta+PgUp";
      "kwin"."Window Minimize" = "Meta+PgDown";
      "kwin"."Window One Desktop Down" = "Meta+Ctrl+Shift+Down";
      "kwin"."Window One Desktop Up" = "Meta+Ctrl+Shift+Up";
      "kwin"."Window One Desktop to the Left" = "Meta+Ctrl+Alt+Left";
      "kwin"."Window One Desktop to the Right" = "Meta+Ctrl+Alt+Right";
      "mediacontrol"."mediavolumedown" = "Meta+Alt+PgDown";
      "mediacontrol"."mediavolumeup" = "Meta+Alt+PgUp";
      "mediacontrol"."nextmedia" = "Meta+Alt+Right";
      "mediacontrol"."playpausemedia" = "Meta+Alt+Space";
      "mediacontrol"."previousmedia" = "Meta+Alt+Left";
      "kwin"."KrohnkiteShiftDown" = "Meta+Down";
      "kwin"."KrohnkiteShiftLeft" = "Meta+Left";
      "kwin"."KrohnkiteShiftRight" = "Meta+Right";
      "kwin"."KrohnkiteShiftUp" = "Meta+Up";
      "ksmserver"."Lock Session" = "";
    };
    configFile = {
      "kwinrc"."Plugins"."krohnkiteEnabled" = true;
      "kwinrc"."Script-krohnkite"."maximizeSoleTile" = true;
      "kwalletrc"."Wallet"."Enabled" = false;
      "kscreenlockerrc"."Daemon"."Autolock" = false;
      "kscreenlockerrc"."Daemon"."LockOnResume" = false;
      "kscreenlockerrc"."Daemon"."Timeout" = 0;
    };
  };
}
