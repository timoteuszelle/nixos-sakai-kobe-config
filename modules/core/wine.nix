{pkgs, ...}: {
  # AMD-specific graphics configuration
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      amdvlk
      rocmPackages.clr
      rocmPackages.clr.icd
    ];
    extraPackages32 = with pkgs; [
      driversi686Linux.amdvlk
    ];
  };

  # Configure system environment for Wine
  environment = {
    sessionVariables = {
      WINEARCH = "win64";
      WINEPREFIX = "$HOME/.wine";
      AMD_VULKAN_ICD = "RADV";
    };
    systemPackages = with pkgs; [
      # Wine and its dependencies
      wineWowPackages.staging
      winetricks
      
      # Gaming optimizations for AMD
      dxvk
      vkd3d-proton    # DirectX 12 support
      mangohud        # Performance monitoring
      gamemode        # Performance optimization
      vulkan-tools    # Vulkan utilities
    ];
  };
}

