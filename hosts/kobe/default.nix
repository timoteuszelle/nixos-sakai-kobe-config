{...}: {
  imports = [
    ./hardware.nix
    ./host-packages.nix
    ../../modules/core/openlinkhub-udev.nix
  ];
  
  # OpenLinkHub module disabled (using Docker setup instead)
  # modules.core.openlinkhub.enable = true;
  
  # Enable only the udev rules for hardware access
  modules.core.openlinkhub-udev.enable = true;
}
