{ config, lib, pkgs, ... }:
with lib;
{
  options.modules.core.openlinkhub = {
    enable = mkEnableOption "OpenLinkHub service";
    
    # Additional configuration options
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

  config = mkIf config.modules.core.openlinkhub.enable {
    # Service configuration
    systemd.user.services.openlinkhub = {
      Unit = {
        Description = "OpenLinkHub Service";
        After = [ "graphical-session.target" ];
        PartOf = [ "graphical-session.target" ];
      };
      
      Service = {
        ExecStart = "${config.modules.core.openlinkhub.package}/bin/openlinkhub";
        Restart = "on-failure";
        RestartSec = 5;
        # Additional service settings for stability
        Environment = [ "PATH=${lib.makeBinPath [ pkgs.coreutils ]}" ];
      };
      
      Install = mkIf config.modules.core.openlinkhub.autoStart {
        WantedBy = [ "graphical-session.target" ];
      };
    };

    # Ensure package is available in case it's not already in host-packages
    # This is a fallback to ensure the package is always available
    environment.systemPackages = [ config.modules.core.openlinkhub.package ];
    
    # Add application desktop entry for integration with desktop environments
    xdg.mime.enable = true;
    
    # Log rotation configuration to prevent log files from growing too large
    services.logrotate = {
      enable = true;
      settings = {
        "/home/*/.*openlinkhub/logs/*.log" = {
          rotate = 7;
          frequency = "daily";
          missingok = true;
          notifempty = true;
          compress = true;
          create = "644 root root";
        };
      };
    };
  };
}

