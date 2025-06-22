{ config, lib, pkgs, ... }:
with lib;
{
  options.modules.core.openlinkhub-udev = {
    enable = mkEnableOption "OpenLinkHub udev rules only";
  };

  config = mkIf config.modules.core.openlinkhub-udev.enable {
    # Create openlinkhub user and group for device access
    users.groups.openlinkhub = {};
    users.users.openlinkhub = {
      group = "openlinkhub";
      isSystemUser = true;
    };

    # Add user to required groups
    users.users.tim.extraGroups = [ "openlinkhub" "plugdev" ];

    # Add udev rules for Corsair devices
    services.udev.extraRules = ''
      # iCUE LINK System Hub
      SUBSYSTEM=="usb", ATTRS{idVendor}=="1b1c", ATTRS{idProduct}=="0c3f", MODE="0666", GROUP="openlinkhub"

      # General Corsair devices
      SUBSYSTEM=="usb", ATTRS{idVendor}=="1b1c", MODE="0666", GROUP="openlinkhub"

      # Additional Corsair devices
      SUBSYSTEM=="hidraw", ATTRS{idVendor}=="1b1c", MODE="0666", GROUP="openlinkhub"

      # i2c devices for memory control
      KERNEL=="i2c-[0-9]*", GROUP="openlinkhub", MODE="0660"
    '';
  };
}

