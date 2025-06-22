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
      # Forceful rules for your specific Corsair devices with actions and tags
      
      # iCUE LINK System Hub (1b1c:0c3f) - primary focus
      ACTION=="add", SUBSYSTEMS=="usb", ATTRS{idVendor}=="1b1c", ATTRS{idProduct}=="0c3f", ENV{DEVTYPE}=="usb_device", TAG+="uaccess", TAG+="systemd", MODE="0660", GROUP="openlinkhub", GROUP+="openlinkhub", OWNER="openlinkhub"
      ACTION=="add", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="1b1c", ATTRS{idProduct}=="0c3f", TAG+="uaccess", TAG+="systemd", MODE="0660", GROUP="openlinkhub", GROUP+="openlinkhub", OWNER="openlinkhub"
      
      # Corsair SCIMITAR PRO RGB Mouse (1b1c:1b3e) - primary focus
      ACTION=="add", SUBSYSTEMS=="usb", ATTRS{idVendor}=="1b1c", ATTRS{idProduct}=="1b3e", ENV{DEVTYPE}=="usb_device", TAG+="uaccess", TAG+="systemd", MODE="0660", GROUP="openlinkhub", GROUP+="openlinkhub", OWNER="openlinkhub"
      ACTION=="add", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="1b1c", ATTRS{idProduct}=="1b3e", TAG+="uaccess", TAG+="systemd", MODE="0660", GROUP="openlinkhub", GROUP+="openlinkhub", OWNER="openlinkhub"
      
      # Bus 001 Device 004 (iCUE LINK System Hub)
      ACTION=="add", KERNELS=="1-4", SUBSYSTEMS=="usb", TAG+="uaccess", TAG+="systemd", MODE="0660", GROUP="openlinkhub", GROUP+="openlinkhub", OWNER="openlinkhub"
      
      # Bus 003 Device 004 (SCIMITAR PRO RGB Mouse)
      ACTION=="add", KERNELS=="3-4", SUBSYSTEMS=="usb", TAG+="uaccess", TAG+="systemd", MODE="0660", GROUP="openlinkhub", GROUP+="openlinkhub", OWNER="openlinkhub"
      
      # Specific hidraw device nodes that are important for your hardware
      ACTION=="add", KERNEL=="hidraw6", SUBSYSTEM=="hidraw", TAG+="uaccess", TAG+="systemd", MODE="0660", GROUP="openlinkhub", GROUP+="openlinkhub", OWNER="openlinkhub"
      ACTION=="add", KERNEL=="hidraw7", SUBSYSTEM=="hidraw", TAG+="uaccess", TAG+="systemd", MODE="0660", GROUP="openlinkhub", GROUP+="openlinkhub", OWNER="openlinkhub"
      ACTION=="add", KERNEL=="hidraw11", SUBSYSTEM=="hidraw", TAG+="uaccess", TAG+="systemd", MODE="0660", GROUP="openlinkhub", GROUP+="openlinkhub", OWNER="openlinkhub"
      ACTION=="add", KERNEL=="hidraw12", SUBSYSTEM=="hidraw", TAG+="uaccess", TAG+="systemd", MODE="0660", GROUP="openlinkhub", GROUP+="openlinkhub", OWNER="openlinkhub"
      
      # Input devices for HID interaction
      KERNEL=="uinput", TAG+="uaccess", TAG+="systemd", MODE="0660", GROUP="input", GROUP+="openlinkhub", OWNER="openlinkhub", OPTIONS+="static_node=uinput"
      
      # General access for all Corsair devices
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="1b1c", MODE="0660", GROUP="openlinkhub", GROUP+="openlinkhub", OWNER="openlinkhub"
      SUBSYSTEM=="hidraw", ATTRS{idVendor}=="1b1c", MODE="0660", GROUP="openlinkhub", GROUP+="openlinkhub", OWNER="openlinkhub"
      
      # Default rules to handle any hidraw devices
      KERNEL=="hidraw*", SUBSYSTEM=="hidraw", MODE="0660", GROUP="openlinkhub", GROUP+="openlinkhub"
      
      # i2c devices for memory control
      KERNEL=="i2c-[0-9]*", GROUP="openlinkhub", GROUP+="openlinkhub", MODE="0660"
      
      # Make all USB device nodes accessible
      SUBSYSTEM=="usb", ENV{DEVTYPE}=="usb_device", MODE="0660", GROUP="openlinkhub", GROUP+="openlinkhub"
      
      # Force specific paths for our known devices
      DEVPATH=="*/usb1/1-4", MODE="0660", OWNER="openlinkhub", GROUP="openlinkhub", GROUP+="openlinkhub"
      DEVPATH=="*/usb3/3-4", MODE="0660", OWNER="openlinkhub", GROUP="openlinkhub", GROUP+="openlinkhub"
    '';
  };
}

