{...}: {
  imports = [
    ./hardware.nix
    ./host-packages.nix
    ./host-services.nix
    ../../modules/core/openlinkhub-udev.nix
    ../../modules/core/openlinkhub.nix
  ];
  
 
}
