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

    # Add comprehensive udev rules for Corsair devices
    services.udev.extraRules = ''
      # Simplify by using wildcards first, then override with specific rules
      
      # All Corsair USB devices (general rule)
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="1b1c", MODE="0660", OWNER="openlinkhub", GROUP="openlinkhub"
      
      # All Corsair HID devices (general rule)
      SUBSYSTEM=="hidraw", ATTRS{idVendor}=="1b1c", MODE="0660", OWNER="openlinkhub", GROUP="openlinkhub"
      
      # Specific devices found in your system with high priority rules
      # iCUE LINK System Hub (Bus 001 Device 004: ID 1b1c:0c3f)
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="1b1c", ATTRS{idProduct}=="0c3f", MODE="0660", OWNER="openlinkhub", GROUP="openlinkhub"
      SUBSYSTEM=="hidraw", ATTRS{idVendor}=="1b1c", ATTRS{idProduct}=="0c3f", MODE="0660", OWNER="openlinkhub", GROUP="openlinkhub"
      
      # Corsair SCIMITAR PRO RGB Mouse (Bus 003 Device 004: ID 1b1c:1b3e)
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="1b1c", ATTRS{idProduct}=="1b3e", MODE="0660", OWNER="openlinkhub", GROUP="openlinkhub"
      SUBSYSTEM=="hidraw", ATTRS{idVendor}=="1b1c", ATTRS{idProduct}=="1b3e", MODE="0660", OWNER="openlinkhub", GROUP="openlinkhub"
      
      # Specific USB device paths with absolute paths for extra certainty
      KERNEL=="1-4", SUBSYSTEM=="usb", MODE="0660", OWNER="openlinkhub", GROUP="openlinkhub"
      KERNEL=="3-4", SUBSYSTEM=="usb", MODE="0660", OWNER="openlinkhub", GROUP="openlinkhub"
      
      # All hidraw devices (ensures access to all HID interfaces)
      KERNEL=="hidraw*", SUBSYSTEM=="hidraw", MODE="0660", GROUP="openlinkhub"
      
      # Specific hidraw devices seen in your system
      KERNEL=="hidraw6", SUBSYSTEM=="hidraw", MODE="0660", OWNER="openlinkhub", GROUP="openlinkhub"
      KERNEL=="hidraw7", SUBSYSTEM=="hidraw", MODE="0660", OWNER="openlinkhub", GROUP="openlinkhub"
      KERNEL=="hidraw11", SUBSYSTEM=="hidraw", MODE="0660", OWNER="openlinkhub", GROUP="openlinkhub"
      KERNEL=="hidraw12", SUBSYSTEM=="hidraw", MODE="0660", OWNER="openlinkhub", GROUP="openlinkhub"
      
      # Input devices
      KERNEL=="uinput", MODE="0660", GROUP="input", OPTIONS+="static_node=uinput", OWNER="openlinkhub"
      
      # Device-specific USB permissions by product ID with consistent GROUP settings
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="1b1c", ATTRS{idProduct}=="0c4e", MODE="0660", OWNER="openlinkhub", GROUP="openlinkhub"
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="1b1c", ATTRS{idProduct}=="0c32", MODE="0660", OWNER="openlinkhub", GROUP="openlinkhub"
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="1b1c", ATTRS{idProduct}=="0c33", MODE="0660", OWNER="openlinkhub", GROUP="openlinkhub"
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="1b1c", ATTRS{idProduct}=="0c39", MODE="0660", OWNER="openlinkhub", GROUP="openlinkhub"
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="1b1c", ATTRS{idProduct}=="0c1c", MODE="0660", OWNER="openlinkhub", GROUP="openlinkhub"
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="1b1c", ATTRS{idProduct}=="0c2a", MODE="0660", OWNER="openlinkhub", GROUP="openlinkhub"
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="1b1c", ATTRS{idProduct}=="0c35", MODE="0660", OWNER="openlinkhub", GROUP="openlinkhub"
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="1b1c", ATTRS{idProduct}=="0c40", MODE="0660", OWNER="openlinkhub", GROUP="openlinkhub"
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="1b1c", ATTRS{idProduct}=="0c36", MODE="0660", OWNER="openlinkhub", GROUP="openlinkhub"
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="1b1c", ATTRS{idProduct}=="0c37", MODE="0660", OWNER="openlinkhub", GROUP="openlinkhub"
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="1b1c", ATTRS{idProduct}=="0c41", MODE="0660", OWNER="openlinkhub", GROUP="openlinkhub"
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="1b1c", ATTRS{idProduct}=="0c1a", MODE="0660", OWNER="openlinkhub", GROUP="openlinkhub"
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="1b1c", ATTRS{idProduct}=="0c0b", MODE="0660", OWNER="openlinkhub", GROUP="openlinkhub"
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="1b1c", ATTRS{idProduct}=="0c10", MODE="0660", OWNER="openlinkhub", GROUP="openlinkhub"
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="1b1c", ATTRS{idProduct}=="0c42", MODE="0660", OWNER="openlinkhub", GROUP="openlinkhub"
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="1b1c", ATTRS{idProduct}=="0c20", MODE="0660", OWNER="openlinkhub", GROUP="openlinkhub"
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="1b1c", ATTRS{idProduct}=="0c21", MODE="0660", OWNER="openlinkhub", GROUP="openlinkhub"
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="1b1c", ATTRS{idProduct}=="0c22", MODE="0660", OWNER="openlinkhub", GROUP="openlinkhub"
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="1b1c", ATTRS{idProduct}=="0c43", MODE="0660", OWNER="openlinkhub", GROUP="openlinkhub"
      
      # Device-specific HID permissions by product ID
      SUBSYSTEM=="hidraw", ATTRS{idVendor}=="1b1c", ATTRS{idProduct}=="0c4e", MODE="0660", OWNER="openlinkhub", GROUP="openlinkhub"
      SUBSYSTEM=="hidraw", ATTRS{idVendor}=="1b1c", ATTRS{idProduct}=="0c32", MODE="0660", OWNER="openlinkhub", GROUP="openlinkhub"
      SUBSYSTEM=="hidraw", ATTRS{idVendor}=="1b1c", ATTRS{idProduct}=="0c33", MODE="0660", OWNER="openlinkhub", GROUP="openlinkhub"
      
      # i2c devices for memory control
      KERNEL=="i2c-[0-9]*", GROUP="openlinkhub", MODE="0660"
      
      # Force permissions on actual USB devices by path
      ACTION=="add", SUBSYSTEM=="usb", KERNELS=="1-4", MODE="0660", OWNER="openlinkhub", GROUP="openlinkhub"
      ACTION=="add", SUBSYSTEM=="usb", KERNELS=="3-4", MODE="0660", OWNER="openlinkhub", GROUP="openlinkhub"
    '';
  };
}

