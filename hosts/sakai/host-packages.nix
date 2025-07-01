{
  pkgs,
  config,
  options,
  inputs,
  ...
}: {
  nixpkgs.config.allowUnfree = true;
  
  environment.systemPackages = 
  let
    unstable = import inputs.nixpkgs-unstable {
      system = pkgs.system;
      config = {
        allowUnfree = true;
      };
    };
  in
  with pkgs; [
    audacity
    discord
    nodejs
    obs-studio
    vlc
    teams-for-linux
    firefox
    thunderbird
    lutris
    wine
    wine64
    winetricks
    cabextract
    obs-studio
    gphoto2
    citrix_workspace
    pkgs.yt-dlp
    pkgs.darktable
    pkgs.framework-tool
    pkgs.easyeffects
    neovim
    vscodium-fhs
    pkgs.ryzenadj
    pkgs.element-desktop
    libreoffice-qt
    hunspell
    hunspellDicts.nl_NL
    hunspellDicts.en_US
    amdgpu_top
    pkgs.nextcloud-client
    pkgs.nextcloud-talk-desktop
    xl2tpd
    libfprint
    ollama
    bc
    fmt
    toybox
    tailscale-systray
    tailscale
    dive
    gh
    openssh
    openssl
    sshs
    mullvad-vpn
    mullvad
    parted
    dosfstools
    pkgs.signal-desktop
    unstable.warp-terminal
    pkgs.whatsapp-for-linux
  ];
}
