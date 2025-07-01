let
  # Import sensitive information from external location
  # This file MUST exist or the build will fail (intentionally)
  mask = import /home/tim/.config/nixos-config/privacy/sakai.nix;
in {
  # Git Configuration (For Pulling Software Repos)
  gitUsername = mask.gitUsername;
  gitEmail = mask.gitEmail;
  gitlabUsername = mask.gitlabUsername;
  gitlabEmail = mask.gitlabEmail;
  githubUsername = mask.githubUsername;
  githubEmail = mask.githubEmail;

  # Hyprland Settings
  extraMonitorSettings = ''
    # Monitor configuration
    monitor=desc:GIGA-BYTE TECHNOLOGY CO. LTD. M28U,3840x2160@60,0x0,1
    monitor=DP-8,preferred,auto,auto
    monitor=eDP-2,preferred,auto,1

    # Workspace assignments
    workspace=1,monitor:eDP-2
    workspace=2,monitor:desc:GIGA-BYTE TECHNOLOGY CO. LTD. M28U
    workspace=3,monitor:DP-8
  '';

  # Waybar Settings
  clock24h = true;

  # Program Options
  browser = "firefox"; # Set Default Browser (google-chrome-stable for google-chrome)
  terminal = "warp-terminal"; # Set Default System Terminal
  keyboardLayout = "us";
  consoleKeyMap = "us";

  # For Nvidia Prime support
  #intelID = "PCI:1:0:0";
  #nvidiaID = "PCI:0:2:0";

  # Enable NFS
  enableNFS = true;

  # Enable Printing Support
  printEnable = true;

  # Set Stylix Image
  stylixImage = ../../wallpapers/rainstreetcar.jpg;

  # Set Waybar
  # Includes alternates such as waybar-curved.nix & waybar-ddubs.nix
  waybarChoice = ../../modules/home/waybar/waybar-simple.nix;

  # Set Animation style
  # Available options are:
  # animations-def.nix  (default)
  # animations-end4.nix (end-4 project)
  # animations-dynamic.nix (ml4w project)
  animChoice = ../../modules/home/hyprland/animations-def.nix;

  # Enable Thunar GUI File Manager
  thunarEnable = true;
}

