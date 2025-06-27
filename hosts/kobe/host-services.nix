{ config, pkgs, ... }:

let
  # Import sensitive information from external location
  # This file MUST exist or the build will fail (intentionally)
  mask = import /home/tim/.config/nixos-config/privacy/kobe.nix;
in {
  # Tailscale configuration
  services.tailscale = {
    enable = true;
  };

  # Network configuration with masked sensitive information
  #networking.nameservers = [ "100.100.100.100" ]; #"1.0.0.1" "1.1.1.1"
  networking.search = [ mask.tailscaleDomain ];
  networking.hosts = {
    "${mask.privateCloudIp}" = [ mask.privateCloudHostname ];
  };

  # Enable the native OpenLinkHub service
  modules.core.openlinkhub = {
    enable = true;
    autoStart = true;
  };

  # Enable webcam support
  modules.core.webcam = {
    enable = true;
    v4l2loopback = {
      enable = true;
      instances = 2; # Create two virtual camera devices
      exclusive_caps = true;
      card_label = "Virtual Camera";
    };
  };

  # Keep the udev rules enabled for proper device access
  modules.core.openlinkhub-udev.enable = true;
}
