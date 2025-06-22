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
      ACTION=="add", SUBSYSTEM=="usb", ATTR{idVendor}=="1b1c", ATTR{idProduct}=="0c3f", TAG+="uaccess", MODE="0660", GROUP="openlinkhub", OWNER="openlinkhub"
      ACTION=="add", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="1b1c", ATTRS{idProduct}=="0c3f", TAG+="uaccess", MODE="0660", GROUP="openlinkhub", OWNER="openlinkhub"
      
      # Corsair SCIMITAR PRO RGB Mouse (1b1c:1b3e) - primary focus
      ACTION=="add", SUBSYSTEM=="usb", ATTR{idVendor}=="1b1c", ATTR{idProduct}=="1b3e", TAG+="uaccess", MODE="0660", GROUP="openlinkhub", OWNER="openlinkhub"
      ACTION=="add", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="1b1c", ATTRS{idProduct}=="1b3e", TAG+="uaccess", MODE="0660", GROUP="openlinkhub", OWNER="openlinkhub"
      
      # Direct device node access for Bus 001 Device 004
      ACTION=="add", KERNEL=="1-4", SUBSYSTEM=="usb", TAG+="uaccess", MODE="0660", GROUP="openlinkhub", OWNER="openlinkhub"
      
      # Direct device node access for Bus 003 Device 004
      ACTION=="add", KERNEL=="3-4", SUBSYSTEM=="usb", TAG+="uaccess", MODE="0660", GROUP="openlinkhub", OWNER="openlinkhub"
      
      # Explicit device path access with ENV targeting
      ACTION=="add", SUBSYSTEMS=="usb", ATTRS{idVendor}=="1b1c", ENV{ID_USB_INTERFACE_NUM}=="00", MODE="0660", GROUP="openlinkhub", OWNER="openlinkhub", TAG+="uaccess"
      
      # Specific hidraw device nodes that are important for your hardware
      ACTION=="add", KERNEL=="hidraw6", SUBSYSTEM=="hidraw", TAG+="uaccess", MODE="0660", GROUP="openlinkhub", OWNER="openlinkhub"
      ACTION=="add", KERNEL=="hidraw7", SUBSYSTEM=="hidraw", TAG+="uaccess", MODE="0660", GROUP="openlinkhub", OWNER="openlinkhub"
      ACTION=="add", KERNEL=="hidraw11", SUBSYSTEM=="hidraw", TAG+="uaccess", MODE="0660", GROUP="openlinkhub", OWNER="openlinkhub"
      ACTION=="add", KERNEL=="hidraw12", SUBSYSTEM=="hidraw", TAG+="uaccess", MODE="0660", GROUP="openlinkhub", OWNER="openlinkhub"
      
      # Input devices for HID interaction
      KERNEL=="uinput", TAG+="uaccess", MODE="0660", GROUP="input", OWNER="openlinkhub", OPTIONS+="static_node=uinput"
      
      # Ensure all Corsair USB devices get proper permissions (fallback)
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="1b1c", MODE="0660", GROUP="openlinkhub", OWNER="openlinkhub"
      
      # Ensure all Corsair HID devices get proper permissions (fallback)
      SUBSYSTEM=="hidraw", ATTRS{idVendor}=="1b1c", MODE="0660", GROUP="openlinkhub", OWNER="openlinkhub"
      
      # Fallback rule for all hidraw devices
      KERNEL=="hidraw*", SUBSYSTEM=="hidraw", MODE="0660", GROUP="openlinkhub"
      
      # i2c devices for memory control
      KERNEL=="i2c-[0-9]*", GROUP="openlinkhub", MODE="0660"
      
      # Make /dev/bus/usb device nodes accessible to openlinkhub
      SUBSYSTEM=="usb", ENV{DEVTYPE}=="usb_device", MODE="0660", GROUP="openlinkhub"
    '';
  };
}

