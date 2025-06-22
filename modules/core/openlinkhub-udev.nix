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
      # iCUE LINK System Hub and other Corsair devices
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="1b1c", ATTRS{idProduct}=="0c3f", MODE="0660", OWNER="openlinkhub", GROUP="openlinkhub"
      SUBSYSTEM=="hidraw", ATTRS{idVendor}=="1b1c", ATTRS{idProduct}=="0c3f", MODE="0660", OWNER="openlinkhub", GROUP="openlinkhub"
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="1b1c", ATTRS{idProduct}=="0c4e", MODE="0660", OWNER="openlinkhub", GROUP="openlinkhub"
      SUBSYSTEM=="hidraw", ATTRS{idVendor}=="1b1c", ATTRS{idProduct}=="0c4e", MODE="0660", OWNER="openlinkhub", GROUP="openlinkhub"
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="1b1c", ATTRS{idProduct}=="0c32", MODE="0660", OWNER="openlinkhub", GROUP="openlinkhub"
      SUBSYSTEM=="hidraw", ATTRS{idVendor}=="1b1c", ATTRS{idProduct}=="0c32", MODE="0660", OWNER="openlinkhub", GROUP="openlinkhub"
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="1b1c", ATTRS{idProduct}=="0c33", MODE="0660", OWNER="openlinkhub", GROUP="openlinkhub"
      SUBSYSTEM=="hidraw", ATTRS{idVendor}=="1b1c", ATTRS{idProduct}=="0c33", MODE="0660", OWNER="openlinkhub", GROUP="openlinkhub"
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="1b1c", ATTRS{idProduct}=="0c39", MODE="0660", OWNER="openlinkhub"
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="1b1c", ATTRS{idProduct}=="0c1c", MODE="0660", OWNER="openlinkhub"
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="1b1c", ATTRS{idProduct}=="0c2a", MODE="0660", OWNER="openlinkhub"
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="1b1c", ATTRS{idProduct}=="0c35", MODE="0660", OWNER="openlinkhub"
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="1b1c", ATTRS{idProduct}=="0c40", MODE="0660", OWNER="openlinkhub"
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="1b1c", ATTRS{idProduct}=="0c36", MODE="0660", OWNER="openlinkhub"
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="1b1c", ATTRS{idProduct}=="0c37", MODE="0660", OWNER="openlinkhub"
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="1b1c", ATTRS{idProduct}=="0c41", MODE="0660", OWNER="openlinkhub"
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="1b1c", ATTRS{idProduct}=="0c1a", MODE="0660", OWNER="openlinkhub"
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="1b1c", ATTRS{idProduct}=="0c0b", MODE="0660", OWNER="openlinkhub"
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="1b1c", ATTRS{idProduct}=="0c10", MODE="0660", OWNER="openlinkhub"
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="1b1c", ATTRS{idProduct}=="0c42", MODE="0660", OWNER="openlinkhub"
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="1b1c", ATTRS{idProduct}=="0c20", MODE="0660", OWNER="openlinkhub"
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="1b1c", ATTRS{idProduct}=="0c21", MODE="0660", OWNER="openlinkhub"
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="1b1c", ATTRS{idProduct}=="0c22", MODE="0660", OWNER="openlinkhub"
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="1b1c", ATTRS{idProduct}=="0c43", MODE="0660", OWNER="openlinkhub"
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="1b1c", ATTRS{idProduct}=="1bfe", MODE="0660", OWNER="openlinkhub"
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="1b1c", ATTRS{idProduct}=="1bd7", MODE="0660", OWNER="openlinkhub"
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="1b1c", ATTRS{idProduct}=="1bfd", MODE="0660", OWNER="openlinkhub"
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="1b1c", ATTRS{idProduct}=="1bc6", MODE="0660", OWNER="openlinkhub"
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="1b1c", ATTRS{idProduct}=="1bb3", MODE="0660", OWNER="openlinkhub"
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="1b1c", ATTRS{idProduct}=="2b10", MODE="0660", OWNER="openlinkhub"
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="1b1c", ATTRS{idProduct}=="2b07", MODE="0660", OWNER="openlinkhub"
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="1b1c", ATTRS{idProduct}=="1bab", MODE="0660", OWNER="openlinkhub"
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="1b1c", ATTRS{idProduct}=="1bc5", MODE="0660", OWNER="openlinkhub"
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="1b1c", ATTRS{idProduct}=="1b7c", MODE="0660", OWNER="openlinkhub"
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="1b1c", ATTRS{idProduct}=="1b7d", MODE="0660", OWNER="openlinkhub"
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="1b1c", ATTRS{idProduct}=="1bdc", MODE="0660", OWNER="openlinkhub"
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="1b1c", ATTRS{idProduct}=="1ba6", MODE="0660", OWNER="openlinkhub"
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="1b1c", ATTRS{idProduct}=="2b00", MODE="0660", OWNER="openlinkhub"
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="1b1c", ATTRS{idProduct}=="0a34", MODE="0660", OWNER="openlinkhub"
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="1b1c", ATTRS{idProduct}=="1b9b", MODE="0660", OWNER="openlinkhub"
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="1b1c", ATTRS{idProduct}=="1bc9", MODE="0660", OWNER="openlinkhub"
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="1b1c", ATTRS{idProduct}=="0c23", MODE="0660", OWNER="openlinkhub"
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="1b1c", ATTRS{idProduct}=="1c05", MODE="0660", OWNER="openlinkhub"
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="1b1c", ATTRS{idProduct}=="1c06", MODE="0660", OWNER="openlinkhub"
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="1b1c", ATTRS{idProduct}=="1c07", MODE="0660", OWNER="openlinkhub"
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="1b1c", ATTRS{idProduct}=="1c1e", MODE="0660", OWNER="openlinkhub"
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="1b1c", ATTRS{idProduct}=="1c08", MODE="0660", OWNER="openlinkhub"
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="1b1c", ATTRS{idProduct}=="1c23", MODE="0660", OWNER="openlinkhub"
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="1b1c", ATTRS{idProduct}=="1c27", MODE="0660", OWNER="openlinkhub"
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="1b1c", ATTRS{idProduct}=="1c1f", MODE="0660", OWNER="openlinkhub"
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="1b1c", ATTRS{idProduct}=="1be3", MODE="0660", OWNER="openlinkhub"
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="1b1c", ATTRS{idProduct}=="1bdb", MODE="0660", OWNER="openlinkhub"
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="1b1c", ATTRS{idProduct}=="1c0c", MODE="0660", OWNER="openlinkhub"
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="1b1c", ATTRS{idProduct}=="2b03", MODE="0660", OWNER="openlinkhub"
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="1b1c", ATTRS{idProduct}=="1b70", MODE="0660", OWNER="openlinkhub"
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="1b1c", ATTRS{idProduct}=="1c0d", MODE="0660", OWNER="openlinkhub"
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="1b1c", ATTRS{idProduct}=="1b93", MODE="0660", OWNER="openlinkhub"
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="1b1c", ATTRS{idProduct}=="1b94", MODE="0660", OWNER="openlinkhub"
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="1b1c", ATTRS{idProduct}=="1b5d", MODE="0660", OWNER="openlinkhub"
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="1b1c", ATTRS{idProduct}=="1b4c", MODE="0660", OWNER="openlinkhub"
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="1b1c", ATTRS{idProduct}=="1bb8", MODE="0660", OWNER="openlinkhub"
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="1b1c", ATTRS{idProduct}=="0c17", MODE="0660", OWNER="openlinkhub"
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="1b1c", ATTRS{idProduct}=="0c18", MODE="0660", OWNER="openlinkhub"
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="1b1c", ATTRS{idProduct}=="0c19", MODE="0660", OWNER="openlinkhub"
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="1b1c", ATTRS{idProduct}=="1b7e", MODE="0660", OWNER="openlinkhub"
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="1b1c", ATTRS{idProduct}=="1b80", MODE="0660", OWNER="openlinkhub"
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="1b1c", ATTRS{idProduct}=="1bf0", MODE="0660", OWNER="openlinkhub"
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="1b1c", ATTRS{idProduct}=="1bf2", MODE="0660", OWNER="openlinkhub"
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="1b1c", ATTRS{idProduct}=="1b9e", MODE="0660", OWNER="openlinkhub"
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="1b1c", ATTRS{idProduct}=="1b75", MODE="0660", OWNER="openlinkhub"
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="1b1c", ATTRS{idProduct}=="1b5e", MODE="0660", OWNER="openlinkhub"
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="1b1c", ATTRS{idProduct}=="0a62", MODE="0660", OWNER="openlinkhub"
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="1b1c", ATTRS{idProduct}=="0a64", MODE="0660", OWNER="openlinkhub"
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="1b1c", ATTRS{idProduct}=="1bac", MODE="0660", OWNER="openlinkhub"
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="1b1c", ATTRS{idProduct}=="1b55", MODE="0660", OWNER="openlinkhub"
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="1b1c", ATTRS{idProduct}=="1b6b", MODE="0660", OWNER="openlinkhub"
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="1b1c", ATTRS{idProduct}=="1b49", MODE="0660", OWNER="openlinkhub"
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="1b1c", ATTRS{idProduct}=="1bb2", MODE="0660", OWNER="openlinkhub"
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="1b1c", ATTRS{idProduct}=="2b01", MODE="0660", OWNER="openlinkhub"
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="1b1c", ATTRS{idProduct}=="2b02", MODE="0660", OWNER="openlinkhub"
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="1b1c", ATTRS{idProduct}=="2b14", MODE="0660", OWNER="openlinkhub"
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="1b1c", ATTRS{idProduct}=="1bb9", MODE="0660", OWNER="openlinkhub"
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="1b1c", ATTRS{idProduct}=="1b73", MODE="0660", OWNER="openlinkhub"
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="1b1c", ATTRS{idProduct}=="1bd4", MODE="0660", OWNER="openlinkhub"
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="1b1c", ATTRS{idProduct}=="2a02", MODE="0660", OWNER="openlinkhub"
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="1b1c", ATTRS{idProduct}=="1b8e", MODE="0660", OWNER="openlinkhub"
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="1b1c", ATTRS{idProduct}=="0c12", MODE="0660", OWNER="openlinkhub"
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="1b1c", ATTRS{idProduct}=="0c13", MODE="0660", OWNER="openlinkhub"
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="1b1c", ATTRS{idProduct}=="0c15", MODE="0660", OWNER="openlinkhub"
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="1b1c", ATTRS{idProduct}=="2b22", MODE="0660", OWNER="openlinkhub"
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="1b1c", ATTRS{idProduct}=="0a6a", MODE="0660", OWNER="openlinkhub"
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="1b1c", ATTRS{idProduct}=="0a97", MODE="0660", OWNER="openlinkhub"
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="1b1c", ATTRS{idProduct}=="1ba4", MODE="0660", OWNER="openlinkhub"
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="1b1c", ATTRS{idProduct}=="1bb5", MODE="0660", OWNER="openlinkhub"
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="1b1c", ATTRS{idProduct}=="1ba1", MODE="0660", OWNER="openlinkhub"
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="1b1c", ATTRS{idProduct}=="1b3d", MODE="0660", OWNER="openlinkhub"
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="1b1c", ATTRS{idProduct}=="0a6b", MODE="0660", OWNER="openlinkhub", GROUP="openlinkhub"
      SUBSYSTEM=="hidraw", ATTRS{idVendor}=="1b1c", ATTRS{idProduct}=="0a6b", MODE="0660", OWNER="openlinkhub", GROUP="openlinkhub"
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="1b1c", ATTRS{idProduct}=="1b3b", MODE="0660", OWNER="openlinkhub", GROUP="openlinkhub"
      SUBSYSTEM=="hidraw", ATTRS{idVendor}=="1b1c", ATTRS{idProduct}=="1b3b", MODE="0660", OWNER="openlinkhub", GROUP="openlinkhub"
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="1b1c", ATTRS{idProduct}=="1b2d", MODE="0660", OWNER="openlinkhub", GROUP="openlinkhub"
      SUBSYSTEM=="hidraw", ATTRS{idVendor}=="1b1c", ATTRS{idProduct}=="1b2d", MODE="0660", OWNER="openlinkhub", GROUP="openlinkhub"
      KERNEL=="uinput", MODE="0660", GROUP="input", OPTIONS+="static_node=uinput", OWNER="openlinkhub"

      # Generic rules for hidraw devices
      KERNEL=="hidraw*", SUBSYSTEM=="hidraw", MODE="0660", GROUP="openlinkhub"

      # Specific Corsair device IDs we know exist on this system
      SUBSYSTEM=="hidraw", ATTRS{idVendor}=="1b1c", ATTRS{idProduct}=="1b3e", MODE="0660", OWNER="openlinkhub", GROUP="openlinkhub"
      SUBSYSTEM=="hidraw", ATTRS{idVendor}=="1b1c", ATTRS{idProduct}=="0c3f", MODE="0660", OWNER="openlinkhub", GROUP="openlinkhub"

      # Add direct rules for known hidraw device nodes
      KERNEL=="hidraw6", SUBSYSTEM=="hidraw", MODE="0660", OWNER="openlinkhub", GROUP="openlinkhub"
      KERNEL=="hidraw7", SUBSYSTEM=="hidraw", MODE="0660", OWNER="openlinkhub", GROUP="openlinkhub"
      KERNEL=="hidraw11", SUBSYSTEM=="hidraw", MODE="0660", OWNER="openlinkhub", GROUP="openlinkhub"
      KERNEL=="hidraw12", SUBSYSTEM=="hidraw", MODE="0660", OWNER="openlinkhub", GROUP="openlinkhub"

      # i2c devices for memory control (retained from original)
      KERNEL=="i2c-[0-9]*", GROUP="openlinkhub", MODE="0660"
    '';
  };
}

