{...}: {
  imports = [
    ./hardware.nix
    ./host-packages.nix
  ];
  
  # Enable OpenLinkHub module
  modules.core.openlinkhub.enable = true;
}
