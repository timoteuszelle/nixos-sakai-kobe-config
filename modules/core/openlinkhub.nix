{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.modules.core.openlinkhub;
in {
  options.modules.core.openlinkhub = {
    enable = mkEnableOption "OpenLinkHub service";
    
    autoStart = mkOption {
      type = types.bool;
      default = true;
      description = "Whether to start OpenLinkHub automatically on login";
    };
    
    package = mkOption {
      type = types.package;
      default = pkgs.openlinkhub;
      description = "The OpenLinkHub package to use";
    };
  };

  config = mkIf cfg.enable {
    # Create openlinkhub user and group
    users.groups.openlinkhub = {};
    users.users.openlinkhub = {
      group = "openlinkhub";
      isSystemUser = true;
      extraGroups = [ "input" ];
    };

    # Add user to required groups
    users.users.tim.extraGroups = [ "openlinkhub" "plugdev" ];

    # Add udev rules for Corsair devices
    services.udev.extraRules = ''
      # iCUE LINK System Hub
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="1b1c", ATTRS{idProduct}=="0c3f", MODE="0666", GROUP="openlinkhub"
      SUBSYSTEM=="hidraw", ATTRS{idVendor}=="1b1c", ATTRS{idProduct}=="0c3f", MODE="0666", GROUP="openlinkhub"
      
      # Corsair SCIMITAR PRO RGB Mouse
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="1b1c", ATTRS{idProduct}=="1b3e", MODE="0666", GROUP="openlinkhub"
      SUBSYSTEM=="hidraw", ATTRS{idVendor}=="1b1c", ATTRS{idProduct}=="1b3e", MODE="0666", GROUP="openlinkhub"
      
      # Generic rules for hidraw devices
      KERNEL=="hidraw*", SUBSYSTEM=="hidraw", MODE="0666", GROUP="openlinkhub"
      
      # Input devices
      KERNEL=="uinput", MODE="0666", GROUP="input", OPTIONS+="static_node=uinput"
      
      # i2c devices for memory control
      KERNEL=="i2c-[0-9]*", GROUP="openlinkhub", MODE="0660"
    '';

    # Open required port
    networking.firewall.allowedTCPPorts = [ 27003 ];
    
    # Service configuration
    systemd.user.services.openlinkhub = {
      description = "OpenLinkHub Service";
      after = [ "graphical-session.target" ];
      partOf = [ "graphical-session.target" ];
      wantedBy = mkIf cfg.autoStart [ "graphical-session.target" ];
      
      serviceConfig = {
        Type = "simple";
        ExecStartPre = [
          # First ExecStartPre: create directories and set up files
          (pkgs.writeShellScript "openlinkhub-setup" ''
            # Create required directories
            ${pkgs.coreutils}/bin/mkdir -p /home/tim/.local/share/openlinkhub/{database,static,web,data}
            ${pkgs.coreutils}/bin/mkdir -p /home/tim/.local/share/openlinkhub/database/{lcd,temperatures,keyboard,rgb,profiles,led}
            ${pkgs.coreutils}/bin/mkdir -p /home/tim/.local/share/openlinkhub/static/fonts
            
            # Copy static files and web content from package
            if [ -d "${cfg.package}/share/openlinkhub/static" ]; then
              ${pkgs.rsync}/bin/rsync -av "${cfg.package}/share/openlinkhub/static/" "/home/tim/.local/share/openlinkhub/static/"
            fi
            if [ -d "${cfg.package}/share/openlinkhub/web" ]; then
              ${pkgs.rsync}/bin/rsync -av "${cfg.package}/share/openlinkhub/web/" "/home/tim/.local/share/openlinkhub/web/"
            fi
            
            # Download font if needed
            if [ ! -f /home/tim/.local/share/openlinkhub/static/fonts/teko.ttf ]; then
              ${pkgs.curl}/bin/curl -L -o /home/tim/.local/share/openlinkhub/static/fonts/teko.ttf \
                "https://raw.githubusercontent.com/google/fonts/main/ofl/teko/Teko-Regular.ttf"
            fi

            # Set up default config if needed
            if [ ! -f /home/tim/.local/share/openlinkhub/config.json ]; then
              cat > /home/tim/.local/share/openlinkhub/config.json << EOF
{
  "debug": true,
  "listenPort": 27003,
  "listenAddress": "127.0.0.1",
  "logLevel": "debug",
  "checkDevicePermission": false
}
EOF
            fi

            # Set up rgb.json if needed
            if [ ! -f /home/tim/.local/share/openlinkhub/database/rgb.json ]; then
              cat > /home/tim/.local/share/openlinkhub/database/rgb.json << EOF
{
  "defaultColor": {
    "red": 255,
    "green": 255,
    "blue": 255,
    "brightness": 1
  },
  "device": "iCUE LINK System Hub",
  "profiles": {
    "static": {
      "speed": 4,
      "brightness": 1,
      "startColor": {
        "red": 0,
        "green": 255,
        "blue": 255,
        "brightness": 1
      },
      "endColor": {
        "red": 0,
        "green": 255,
        "blue": 255,
        "brightness": 1
      }
    }
  }
}
EOF
            fi

            # Ensure correct permissions
            chown -R tim:users /home/tim/.local/share/openlinkhub
          '')
          
          # Second ExecStartPre: ensure directory exists
          "${pkgs.coreutils}/bin/mkdir -p /home/tim/.local/share/openlinkhub"
        ];
        ExecStart = toString (pkgs.writeShellScript "openlinkhub-wrapper" ''
          # Include pciutils in PATH to fix "lspci not found" error
          # Include pciutils in PATH to fix "lspci not found" error
          export PATH=${lib.makeBinPath [ cfg.package pkgs.pciutils ]}:$PATH
          cd /home/tim/.local/share/openlinkhub
          # Run with debug output
          exec ${cfg.package}/bin/OpenLinkHub
        '');
        Restart = "on-failure";
        RestartSec = 5;
      };
    };

    # Required packages
    environment.systemPackages = with pkgs; [ 
      cfg.package
      pciutils
      curl
      rsync
      rocmPackages.rocm-smi
      radeontop
      
      (pkgs.writeShellScriptBin "amd-smi" ''
        exec ${pkgs.rocmPackages.rocm-smi}/bin/rocm-smi "$@"
      '')
    ];
    
    # XDG desktop integration
    xdg = {
      mime.enable = true;
      portal = {
        enable = true;
        extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
      };
    };
    
    environment.pathsToLink = [ "/share/applications" ];
  };
}
