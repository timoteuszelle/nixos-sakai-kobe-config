{...}: {
  imports = [
    ./hardware.nix
    ./host-packages.nix
  ];
  
  # OpenLinkHub module disabled (using Docker setup instead)
  # modules.core.openlinkhub.enable = true;
}
