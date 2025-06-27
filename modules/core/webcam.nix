{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.modules.core.webcam;
in
{
  options.modules.core.webcam = {
    enable = mkEnableOption "Enable webcam support";
    
    v4l2loopback = {
      enable = mkEnableOption "Enable v4l2loopback for virtual webcam devices";
      
      instances = mkOption {
        type = types.int;
        default = 1;
        description = "Number of v4l2loopback devices to create";
      };
      
      exclusive_caps = mkOption {
        type = types.bool;
        default = true;
        description = "Whether to set exclusive_caps for better application compatibility";
      };
      
      card_label = mkOption {
        type = types.str;
        default = "Virtual Camera";
        description = "Label for the virtual camera device";
      };
    };
  };
  
  config = mkIf cfg.enable {
    # Enable USB video class support
    hardware.enableAllFirmware = true;
    
    # Load necessary webcam kernel modules
    boot.kernelModules = mkMerge [
      # Always load UVC video driver
      [ "uvcvideo" ]
      
      # Conditionally load v4l2loopback if enabled
      (mkIf cfg.v4l2loopback.enable [ "v4l2loopback" ])
    ];
    
    # Configure v4l2loopback if enabled
    boot.extraModulePackages = mkIf cfg.v4l2loopback.enable [
      config.boot.kernelPackages.v4l2loopback
    ];
    
    boot.extraModprobeConfig = mkIf cfg.v4l2loopback.enable ''
      options v4l2loopback devices=${toString cfg.v4l2loopback.instances} exclusive_caps=${if cfg.v4l2loopback.exclusive_caps then "1" else "0"} card_label="${cfg.v4l2loopback.card_label}"
    '';
    
    # Add udev rules for better webcam device permissions
    services.udev.extraRules = ''
      # Give video group access to webcam devices
      KERNEL=="video[0-9]*", GROUP="video", MODE="0660"
      
      # Canon camera specific rules (adjust vendor/product ID if needed)
      SUBSYSTEM=="usb", ATTRS{idVendor}=="04a9", GROUP="video", MODE="0660"
      
      # USB Video Class devices
      SUBSYSTEM=="usb", ENV{DEVTYPE}=="usb_device", ENV{ID_USB_INTERFACES}=="*:0e0100:*", GROUP="video", MODE="0660"
    '';
    
    # Note: Make sure to add your user to the 'video' group 
    # for proper camera access permissions
    
    # Install helpful webcam utilities
    environment.systemPackages = with pkgs; [
      v4l-utils # Provides v4l2-ctl and other utilities for webcam management
    ];
  };
}

