{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.modules.core.openlinkhub-docker;
  composeDir = "/home/tim/pod-dirs-files/openlinkhub";
  dataDir = "${composeDir}/data";
  # Fixed user and group IDs as in the current Dockerfile
  uid = 988;
  gid = 984;
in
{
  options.modules.core.openlinkhub-docker = {
    enable = mkEnableOption "Docker-based OpenLinkHub service";
    
    autoStart = mkOption {
      type = types.bool;
      default = true;
      description = "Whether to start OpenLinkHub container automatically on boot";
    };
    
    buildFromSource = mkOption {
      type = types.bool;
      default = true;
      description = "Whether to build OpenLinkHub from source in the container";
    };
    
    sourceDir = mkOption {
      type = types.str;
      default = "/home/tim/OpenLinkHub";
      description = "Directory containing OpenLinkHub source code";
    };
    
    user = mkOption {
      type = types.str;
      default = "openlinkhub";
      description = "User to run OpenLinkHub as";
    };
    
    group = mkOption {
      type = types.str;
      default = "openlinkhub";
      description = "Group to run OpenLinkHub as";
    };
    
    port = mkOption {
      type = types.int;
      default = 27003;
      description = "Port for OpenLinkHub web interface";
    };
    
    debug = mkOption {
      type = types.bool;
      default = true;
      description = "Enable debug logging";
    };
  };

  config = mkIf cfg.enable {
    # Create openlinkhub user and group with fixed IDs for container compatibility
    users.groups.${cfg.group} = {
      gid = gid;
    };
    users.users.${cfg.user} = {
      uid = uid;
      group = cfg.group;
      isSystemUser = true;
    };
    
    # Add the local user to required groups
    users.users.tim.extraGroups = [ cfg.group "plugdev" "docker" ];
    
    # Make sure Docker is installed and running
    virtualisation.docker = {
      enable = true;
      autoPrune.enable = true;
    };

    # Use the dockerComposeSupport feature
    virtualisation.oci-containers.docker = {
      enable = true;
    };
    
    # Create a custom Dockerfile with fixed issues
    system.activationScripts.openlinkhub-docker-setup = ''
      # Ensure the data directory structure exists
      mkdir -p ${dataDir}/{database,static,web}
      mkdir -p ${composeDir}/config
      
      # Create or update the Dockerfile with corrections
      cat > ${composeDir}/config/Dockerfile << 'EOF'
FROM golang:1.21-bullseye AS build

# Install build dependencies
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y \
    libudev-dev \
    gcc \
    g++ \
    pkg-config \
    git \
    make \
    libusb-1.0-0-dev \
    libhidapi-dev

# Set proper Go environment variables
ENV CGO_ENABLED=1
ENV GO111MODULE=on
ENV GOOS=linux
ENV GOARCH=amd64

# Use existing code from host
WORKDIR /app/OpenLinkHub
COPY . .

# Build the application with proper flags
RUN go build -v -ldflags="-s -w" -o OpenLinkHub .

FROM debian:bullseye-slim

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
    apt-get install -y \
    libudev-dev \
    pciutils \
    usbutils \
    libusb-1.0-0 \
    libhidapi-libusb0 \
    udev \
    procps \
    net-tools \
    iproute2 \
    hwinfo \
    dmidecode && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Create proper device nodes if missing (will be overridden by mounts)
RUN mkdir -p /dev/bus/usb/001 /dev/bus/usb/003 /etc/udev/rules.d

# Create all required groups with proper IDs
RUN groupadd -g ${toString gid} openlinkhub && \
    groupadd -g 986 input || true && \
    groupadd -g 46 plugdev || true && \
    useradd -u ${toString uid} -g openlinkhub -G input,plugdev -m -s /bin/bash openlinkhub

# Copy udev rules for device access
COPY --from=build /app/OpenLinkHub/99-openlinkhub.rules /etc/udev/rules.d/
RUN chmod 644 /etc/udev/rules.d/99-openlinkhub.rules

# Create directories with proper permissions
RUN mkdir -p /opt/OpenLinkHub && \
    chown -R openlinkhub:openlinkhub /opt/OpenLinkHub

# Copy application and resources
COPY --from=build /app/OpenLinkHub/OpenLinkHub /opt/OpenLinkHub/
COPY --from=build /app/OpenLinkHub/database /opt/OpenLinkHub/database
COPY --from=build /app/OpenLinkHub/static /opt/OpenLinkHub/static
COPY --from=build /app/OpenLinkHub/web /opt/OpenLinkHub/web

WORKDIR /opt/OpenLinkHub

# Set permissions on copied files
RUN chown -R openlinkhub:openlinkhub /opt/OpenLinkHub

# Switch to non-root user
USER openlinkhub

# Use ENTRYPOINT for more consistent behavior
ENTRYPOINT ["/opt/OpenLinkHub/OpenLinkHub"]
# Set default arguments that can be overridden
CMD ["-host", "0.0.0.0", "-port", "27003"]
EOF
      
      # Create or update docker-compose.yml
      cat > ${composeDir}/docker-compose.yml << 'EOF'
services:
  openlinkhub:
    build:
      context: ${cfg.sourceDir}
      dockerfile: ${composeDir}/config/Dockerfile
    volumes:
      - ${dataDir}/database:/opt/OpenLinkHub/database
      - ${dataDir}/static:/opt/OpenLinkHub/static
      - ${dataDir}/web:/opt/OpenLinkHub/web
      - ${dataDir}/config.json:/opt/OpenLinkHub/config.json
      - /sys:/sys:ro
      - /proc:/proc:ro
    ports:
      - "0.0.0.0:${toString cfg.port}:${toString cfg.port}"
    devices:
      # Map all USB devices
      - "/dev/bus/usb:/dev/bus/usb"
      # Map all hidraw devices
      - "/dev/hidraw*:/dev/hidraw*"
      # Map uinput for input device support
      - "/dev/uinput:/dev/uinput"
      # System devices for hardware monitoring
      - "/dev/mem:/dev/mem"
      # Add i2c devices if available
      - "/dev/i2c-*:/dev/i2c-*"
    environment:
      # Set user IDs to match host's openlinkhub user
      - PUID=${toString uid}
      - PGID=${toString gid}
      # Enable debug logging if configured
      - DEBUG=${if cfg.debug then "1" else "0"}
      - VERBOSE=${if cfg.debug then "1" else "0"}
      - LOG_LEVEL=${if cfg.debug then "debug" else "info"}
      - OPENLINKHUB_DEBUG=${if cfg.debug then "1" else "0"}
    # For hardware access
    privileged: true
    # Add the container to the host's groups
    group_add:
      - "${toString gid}"  # openlinkhub
      - "986"  # input
      - "46"   # plugdev
    restart: unless-stopped
    # Command with proper flags
    command: "-host 0.0.0.0 -port ${toString cfg.port} ${if cfg.debug then "-debug -verbose -log_level=debug" else ""} -check_device_permission=false"
    # Use host networking for better device access
    network_mode: "host"
EOF

      # Create a default config.json if it doesn't exist
      if [ ! -f ${dataDir}/config.json ]; then
        cat > ${dataDir}/config.json << 'EOF'
{
  "debug": ${if cfg.debug then "true" else "false"},
  "listenPort": ${toString cfg.port},
  "listenAddress": "0.0.0.0",
  "manual": false,
  "frontend": true,
  "metrics": false,
  "memory": false,
  "memorySmBus": "i2c-0",
  "memoryType": 4,
  "exclude": [],
  "decodeMemorySku": true,
  "memorySku": "",
  "resumeDelay": 15000,
  "logLevel": "${if cfg.debug then "debug" else "info"}",
  "logFile": "",
  "enhancementKits": [],
  "temperatureOffset": 0,
  "amdGpuIndex": 0,
  "amdsmiPath": "",
  "checkDevicePermission": false,
  "cpuTempFile": "",
  "graphProfiles": false,
  "ramTempViaHwmon": false,
  "led": true,
  "devices": [
    {
      "type": "mouse",
      "name": "Corsair SCIMITAR PRO RGB Mouse",
      "vendorId": "1b1c",
      "productId": "1b3e",
      "enabled": true,
      "features": {
        "rgb": true,
        "buttonMapping": true,
        "dpi": true
      },
      "zones": [
        "logo",
        "wheel",
        "side"
      ],
      "buttons": [
        {"id": 1, "name": "Left Click"},
        {"id": 2, "name": "Right Click"},
        {"id": 3, "name": "Middle Click"},
        {"id": 4, "name": "Back"},
        {"id": 5, "name": "Forward"},
        {"id": 6, "name": "DPI Up"},
        {"id": 7, "name": "DPI Down"},
        {"id": 8, "name": "Side Button 1"},
        {"id": 9, "name": "Side Button 2"},
        {"id": 10, "name": "Side Button 3"},
        {"id": 11, "name": "Side Button 4"},
        {"id": 12, "name": "Side Button 5"},
        {"id": 13, "name": "Side Button 6"},
        {"id": 14, "name": "Side Button 7"},
        {"id": 15, "name": "Side Button 8"},
        {"id": 16, "name": "Side Button 9"},
        {"id": 17, "name": "Side Button 10"},
        {"id": 18, "name": "Side Button 11"},
        {"id": 19, "name": "Side Button 12"}
      ],
      "dpiSettings": {
        "stages": 5,
        "defaultStage": 2,
        "range": {
          "min": 100,
          "max": 16000
        }
      }
    }
  ]
}
EOF
      fi
      
      # Set proper permissions
      chown -R ${cfg.user}:${cfg.group} ${dataDir}
      chmod -R 755 ${dataDir}
    '';
    
    # Create a systemd service to manage the Docker container
    systemd.services.openlinkhub-docker = {
      description = "OpenLinkHub Docker Container";
      wantedBy = mkIf cfg.autoStart [ "multi-user.target" ];
      after = [ "docker.service" "docker.socket" "network.target" ];
      requires = [ "docker.service" ];
      
      path = with pkgs; [
        docker-compose
        docker
      ];
      
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        WorkingDirectory = composeDir;
        User = "root";  # Need root to access devices
        
        # Start the container
        ExecStart = "${pkgs.docker-compose}/bin/docker-compose -f ${composeDir}/docker-compose.yml up -d";
        
        # Stop the container
        ExecStop = "${pkgs.docker-compose}/bin/docker-compose -f ${composeDir}/docker-compose.yml down";
        
        # Rebuild and restart on config changes
        ExecReload = "${pkgs.docker-compose}/bin/docker-compose -f ${composeDir}/docker-compose.yml up -d --build";
      };
    };
    
    # Add udev rules for Corsair devices - same as in openlinkhub-udev.nix
    services.udev.extraRules = ''
      # iCUE LINK System Hub (1b1c:0c3f)
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="1b1c", ATTRS{idProduct}=="0c3f", MODE="0660", GROUP="${cfg.group}", OWNER="${cfg.user}", TAG+="uaccess"
      SUBSYSTEM=="hidraw", ATTRS{idVendor}=="1b1c", ATTRS{idProduct}=="0c3f", MODE="0660", GROUP="${cfg.group}", OWNER="${cfg.user}", TAG+="uaccess"
      
      # Corsair SCIMITAR PRO RGB Mouse (1b1c:1b3e)
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="1b1c", ATTRS{idProduct}=="1b3e", MODE="0660", GROUP="${cfg.group}", OWNER="${cfg.user}", TAG+="uaccess"
      SUBSYSTEM=="hidraw", ATTRS{idVendor}=="1b1c", ATTRS{idProduct}=="1b3e", MODE="0660", GROUP="${cfg.group}", OWNER="${cfg.user}", TAG+="uaccess"
      
      # General fallback rules for all Corsair devices
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="1b1c", MODE="0660", GROUP="${cfg.group}", OWNER="${cfg.user}"
      SUBSYSTEM=="hidraw", ATTRS{idVendor}=="1b1c", MODE="0660", GROUP="${cfg.group}", OWNER="${cfg.user}"
      
      # Input devices for HID interaction
      KERNEL=="uinput", MODE="0660", GROUP="input", OWNER="${cfg.user}", OPTIONS+="static_node=uinput"
      
      # i2c devices for memory control
      KERNEL=="i2c-[0-9]*", MODE="0660", GROUP="${cfg.group}"
    '';
    
    # Open required port
    networking.firewall = {
      allowedTCPPorts = [ cfg.port ];
    };
    
    # Required packages
    environment.systemPackages = with pkgs; [
      docker-compose
      docker
      pciutils
      usbutils
      lshw
      hwinfo
    ];
  };
}

