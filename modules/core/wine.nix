{pkgs, ...}: {
  # Enable 32-bit support for Wine
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };

  # Enable Wine with proper configuration
  programs.wine.enable = true;

  # Add necessary environment variables for Wine
  environment = {
    sessionVariables = {
      WINEARCH = "win64";
      WINEPREFIX = "$HOME/.wine";
    };
    systemPackages = with pkgs; [
      # Use the pre-built wine package
      wine64
      winetricks
      
      # Additional dependencies
      cabextract  # Needed for winetricks
      dxvk        # DirectX to Vulkan translation
    ];
  };
}

