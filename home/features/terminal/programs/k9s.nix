{ pkgs, ... }: {
  programs.k9s = {
    enable = true;

    # k9s settings
    settings.k9s = {
      liveViewAutoRefresh = false;
      refreshRate = 2;
      apiServerTimeout = "15s";
      maxConnRetry = 5;
      readOnly = false;
      noExitOnCtrlC = false;
      portForwardAddress = "localhost";
      ui = {
        skin = "skin";
        enableMouse = false;
        headless = false;
        logoless = false;
        crumbsless = false;
        splashless = false;
        reactive = false;
        noIcons = false;
        defaultsToFullScreen = false;
        useFullGVRTitle = false;
      };
      skipLatestRevCheck = false;
      disablePodCounting = false;
      shellPod = {
        image = "busybox:1.35.0";
        namespace = "default";
        limits = {
          cpu = "100m";
          memory = "100Mi";
        };
      };
      imageScans = {
        enable = false;
        exclusions = {
          namespaces = [ ];
          labels = { };
        };
      };
      logger = {
        tail = 100;
        buffer = 5000;
        sinceSeconds = -1;
        textWrap = false;
        disableAutoscroll = false;
        showTime = false;
      };
      thresholds = {
        cpu = {
          critical = 90;
          warn = 70;
        };
        memory = {
          critical = 90;
          warn = 70;
        };
      };
      defaultView = "";
    };

    # Aliases
    aliases.aliases = {
      dp = "deployments";
      sec = "v1/secrets";
      jo = "jobs";
      cr = "clusterroles";
      crb = "clusterrolebindings";
      ro = "roles";
      rb = "rolebindings";
      np = "networkpolicies";
    };

    # Catppuccin Macchiato theme
    skins.skin = {
      k9s = {
        body = {
          fgColor = "#CAD3F5";
          bgColor = "default";
          logoColor = "#C6A0F6";
        };
        prompt = {
          fgColor = "#CAD3F5";
          bgColor = "default";
          suggestColor = "#8AADF4";
        };
        help = {
          fgColor = "#CAD3F5";
          bgColor = "default";
          sectionColor = "#A6DA95";
          keyColor = "#8AADF4";
          numKeyColor = "#EE99A0";
        };
        frame = {
          title = {
            fgColor = "#8BD5CA";
            bgColor = "default";
            highlightColor = "#F5BDE6";
            counterColor = "#EED49F";
            filterColor = "#A6DA95";
          };
          border = {
            fgColor = "#C6A0F6";
            focusColor = "#B7BDF8";
          };
          menu = {
            fgColor = "#CAD3F5";
            keyColor = "#8AADF4";
            numKeyColor = "#EE99A0";
          };
          crumbs = {
            fgColor = "#24273A";
            bgColor = "default";
            activeColor = "#F0C6C6";
          };
          status = {
            newColor = "#8AADF4";
            modifyColor = "#B7BDF8";
            addColor = "#A6DA95";
            pendingColor = "#F5A97F";
            errorColor = "#ED8796";
            highlightColor = "#91D7E3";
            killColor = "#C6A0F6";
            completedColor = "#6E738D";
          };
        };
        info = {
          fgColor = "#F5A97F";
          sectionColor = "#CAD3F5";
        };
        views = {
          table = {
            fgColor = "#CAD3F5";
            bgColor = "default";
            cursorFgColor = "#363A4F";
            cursorBgColor = "#494D64";
            markColor = "#F4DBD6";
            header = {
              fgColor = "#EED49F";
              bgColor = "default";
              sorterColor = "#91D7E3";
            };
          };
          xray = {
            fgColor = "#CAD3F5";
            bgColor = "default";
            cursorColor = "#494D64";
            cursorTextColor = "#24273A";
            graphicColor = "#F5BDE6";
          };
          charts = {
            bgColor = "default";
            chartBgColor = "default";
            dialBgColor = "default";
            defaultDialColors = [
              "#A6DA95"
              "#ED8796"
            ];
            defaultChartColors = [
              "#A6DA95"
              "#ED8796"
            ];
            resourceColors = {
              cpu = [
                "#C6A0F6"
                "#8AADF4"
              ];
              mem = [
                "#EED49F"
                "#F5A97F"
              ];
            };
          };
          yaml = {
            keyColor = "#8AADF4";
            valueColor = "#CAD3F5";
            colonColor = "#A5ADCB";
          };
          logs = {
            fgColor = "#CAD3F5";
            bgColor = "default";
            indicator = {
              fgColor = "#B7BDF8";
              bgColor = "default";
              toggleOnColor = "#A6DA95";
              toggleOffColor = "#A5ADCB";
            };
          };
        };
        dialog = {
          fgColor = "#EED49F";
          bgColor = "default";
          buttonFgColor = "#24273A";
          buttonBgColor = "default";
          buttonFocusFgColor = "#24273A";
          buttonFocusBgColor = "#F5BDE6";
          labelFgColor = "#F4DBD6";
          fieldFgColor = "#CAD3F5";
        };
      };
    };
  };
}
