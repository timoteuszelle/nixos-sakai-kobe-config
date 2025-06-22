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

    # Add essential udev rules for Corsair devices
    services.udev.extraRules = ''
      # iCUE LINK System Hub (1b1c:0c3f)
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="1b1c", ATTRS{idProduct}=="0c3f", MODE="0660", GROUP="openlinkhub", OWNER="openlinkhub", TAG+="uaccess"
      SUBSYSTEM=="hidraw", ATTRS{idVendor}=="1b1c", ATTRS{idProduct}=="0c3f", MODE="0660", GROUP="openlinkhub", OWNER="openlinkhub", TAG+="uaccess"
      
      # Corsair SCIMITAR PRO RGB Mouse (1b1c:1b3e)
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="1b1c", ATTRS{idProduct}=="1b3e", MODE="0660", GROUP="openlinkhub", OWNER="openlinkhub", TAG+="uaccess"
      SUBSYSTEM=="hidraw", ATTRS{idVendor}=="1b1c", ATTRS{idProduct}=="1b3e", MODE="0660", GROUP="openlinkhub", OWNER="openlinkhub", TAG+="uaccess"
      
      # Specific USB paths for your devices
      KERNEL=="1-4", SUBSYSTEM=="usb", MODE="0660", GROUP="openlinkhub", OWNER="openlinkhub", TAG+="uaccess"
      KERNEL=="3-4", SUBSYSTEM=="usb", MODE="0660", GROUP="openlinkhub", OWNER="openlinkhub", TAG+="uaccess"
      
      # Specific hidraw devices for your hardware
      KERNEL=="hidraw6", SUBSYSTEM=="hidraw", MODE="0660", GROUP="openlinkhub", OWNER="openlinkhub", TAG+="uaccess"
      KERNEL=="hidraw7", SUBSYSTEM=="hidraw", MODE="0660", GROUP="openlinkhub", OWNER="openlinkhub", TAG+="uaccess"
      KERNEL=="hidraw11", SUBSYSTEM=="hidraw", MODE="0660", GROUP="openlinkhub", OWNER="openlinkhub", TAG+="uaccess"
      KERNEL=="hidraw12", SUBSYSTEM=="hidraw", MODE="0660", GROUP="openlinkhub", OWNER="openlinkhub", TAG+="uaccess"
      
      # Input devices for HID interaction
      KERNEL=="uinput", MODE="0660", GROUP="input", OWNER="openlinkhub", OPTIONS+="static_node=uinput"
      
      # General fallback rules for all Corsair devices
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="1b1c", MODE="0660", GROUP="openlinkhub", OWNER="openlinkhub"
      SUBSYSTEM=="hidraw", ATTRS{idVendor}=="1b1c", MODE="0660", GROUP="openlinkhub", OWNER="openlinkhub"
      
      # i2c devices for memory control
      KERNEL=="i2c-[0-9]*", MODE="0660", GROUP="openlinkhub"
    '';
  };
}

