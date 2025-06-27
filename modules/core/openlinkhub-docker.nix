{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.modules.core.openlinkhub-docker;
in {
  options.modules.core.openlinkhub-docker = {
    enable = mkEnableOption "Docker-based OpenLinkHub service";
    
    autoStart = mkOption {
      type = types.bool;
      default = true;
      description = "Whether to start OpenLinkHub container automatically";
    };
    
    debug = mkOption {
      type = types.bool;
      default = true;
      description = "Enable debug logging";
    };
    
    sourceDir = mkOption {
      type = types.str;
      default = "/home/tim/OpenLinkHub";
      description = "Directory containing OpenLinkHub source files";
    };
  };

  config = mkIf cfg.enable {
    virtualisation.oci-containers = {
      backend = "docker";
      containers = {
        openlinkhub = {
          image = "openlinkhub:latest";
          autoStart = cfg.autoStart;
          volumes = [
            "/home/tim/openlinkhub/database:/opt/OpenLinkHub/database"  # Mount entire database directory
            "/home/tim/openlinkhub/data:/opt/OpenLinkHub/data"
            "/home/tim/openlinkhub/config.json:/opt/OpenLinkHub/config.json"
            "${cfg.sourceDir}/static:/opt/OpenLinkHub/static:ro"
            "${cfg.sourceDir}/web:/opt/OpenLinkHub/web:ro"
          ];
          environment = {
            TZ = "Europe/Amsterdam";
            PUID = "988";
            PGID = "984";
            DEBUG = if cfg.debug then "true" else "false";
          };
          extraOptions = [
            "--network=host"
            "--privileged"  # Keep this for full device access
            "--memory=512m"
            "--memory-swap=1g"
            "--cpu-shares=512"
            "--device=/dev/bus/usb:/dev/bus/usb"
            "--device=/dev/uinput:/dev/uinput"
            "--device=/dev/hidraw6:/dev/hidraw6"
            "--device=/dev/hidraw7:/dev/hidraw7"
            "--device=/dev/hidraw11:/dev/hidraw11"
            "--device=/dev/hidraw12:/dev/hidraw12"
          ];
        };
      };
    };

  # Create user and group
  users.groups.openlinkhub.gid = 984;
  users.users.openlinkhub = {
    uid = 988;
    group = "openlinkhub";
    isSystemUser = true;
  };
  
  users.users.tim.extraGroups = [ "openlinkhub" "plugdev" ];

  # Setup directories and config
  systemd.tmpfiles.rules = [
    "d /home/tim/openlinkhub 0770 988 984 -"
    "d /home/tim/openlinkhub/data 0770 988 984 -"
    "d /home/tim/openlinkhub/database 0770 988 984 -"
    "d /home/tim/openlinkhub/database/led 0770 988 984 -"
    "d /home/tim/openlinkhub/database/rgb 0770 988 984 -"
    "d /home/tim/openlinkhub/database/lcd 0770 988 984 -"
    "d /home/tim/openlinkhub/database/temperatures 0770 988 984 -"
    "d /home/tim/openlinkhub/database/keyboard 0770 988 984 -"
    "d /home/tim/openlinkhub/database/profiles 0770 988 984 -"
  ];

  # Initial configuration setup
  systemd.services.openlinkhub-config = {
    description = "Configure OpenLinkHub";
    wantedBy = [ "multi-user.target" ];
    after = [ "docker.service" ];
    before = [ "docker-container@openlinkhub.service" ];
    requisite = [ "docker.service" ];
    path = [ pkgs.coreutils ];
    script = ''
      if [ ! -f /home/tim/openlinkhub/config.json ]; then
        cat > /home/tim/openlinkhub/config.json << EOF
{
  "debug": ${if cfg.debug then "true" else "false"},
  "listenPort": 27003,
  "listenAddress": "0.0.0.0",
  "logLevel": ${if cfg.debug then "\"debug\"" else "\"info\""},
  "checkDevicePermission": false
}
EOF
      fi
      chown -R 988:984 /home/tim/openlinkhub
      chmod 644 /home/tim/openlinkhub/config.json
    '';
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      User = "root";
    };
  };

  # udev rules for Corsair devices
  services.udev.extraRules = ''
    # iCUE LINK System Hub
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="1b1c", ATTRS{idProduct}=="0c3f", MODE="0666", GROUP="openlinkhub", TAG+="uaccess"
    SUBSYSTEM=="hidraw", ATTRS{idVendor}=="1b1c", ATTRS{idProduct}=="0c3f", MODE="0666", GROUP="openlinkhub", TAG+="uaccess"
    
    # Corsair SCIMITAR PRO RGB Mouse
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="1b1c", ATTRS{idProduct}=="1b3e", MODE="0666", GROUP="openlinkhub", TAG+="uaccess"
    SUBSYSTEM=="hidraw", ATTRS{idVendor}=="1b1c", ATTRS{idProduct}=="1b3e", MODE="0666", GROUP="openlinkhub", TAG+="uaccess"
    
    # General Corsair devices
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="1b1c", MODE="0666", GROUP="openlinkhub", TAG+="uaccess"
    SUBSYSTEM=="hidraw", ATTRS{idVendor}=="1b1c", MODE="0666", GROUP="openlinkhub", TAG+="uaccess"
    
    # Input devices
    KERNEL=="uinput", MODE="0666", GROUP="openlinkhub", TAG+="uaccess"
    
    # i2c devices
    KERNEL=="i2c-[0-9]*", MODE="0666", GROUP="openlinkhub"
  '';

  # Open firewall port
  networking.firewall.allowedTCPPorts = [ 27003 ];
  # Required packages
  environment.systemPackages = with pkgs; [
    docker
    pciutils
    usbutils
    lshw
    hwinfo
    hidapi
    libusb1
    systemd.dev  # For libudev
  ];
};  # Add semicolon after closing the config = mkIf cfg.enable block
}   # Module closing brace
