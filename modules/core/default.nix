{ inputs, ... }:
{
  imports = [
    ./boot.nix
    ./flatpak.nix
    ./fonts.nix
    ./greetd.nix
    ./hardware.nix
    ./network.nix
    ./nfs.nix
    ./nh.nix
    ./packages.nix
    ./printing.nix
    ./security.nix
    ./services.nix
    ./starfish.nix
    ./steam.nix
    ./stylix.nix
    ./syncthing.nix
    ./system.nix
    ./thunar.nix
    ./user.nix
    ./virtualisation.nix
    ./wine.nix
    ./xserver.nix
    inputs.stylix.nixosModules.stylix
  ];
}
