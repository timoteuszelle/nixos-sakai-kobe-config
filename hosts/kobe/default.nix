{...}: {
  imports = [
    ./hardware.nix
    ./host-packages.nix
    ../../modules/core/openlinkhub-udev.nix
    ../../modules/core/openlinkhub.nix
  ];
  
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
      instances = 2;  # Create two virtual camera devices
      exclusive_caps = true;
      card_label = "Virtual Camera";
    };
  };
  
  # Keep the udev rules enabled for proper device access
  modules.core.openlinkhub-udev.enable = true;
}
