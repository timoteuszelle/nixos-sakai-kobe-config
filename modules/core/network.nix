{
  pkgs,
  host,
  options,
  ...
}: {
  networking = {
    hostName = "${host}";
    networkmanager.enable = true;
    timeServers = options.networking.timeServers.default ++ ["pool.ntp.org"];
    firewall = {
      enable = true;
      allowedTCPPorts = [
        22
        80
        443
        59010
        59011
        8080
      ];
      allowedUDPPorts = [
        59010
        59011
        41641  # Tailscale default port
        3478   # STUN for Tailscale
      ];
    };
  };

  environment.systemPackages = with pkgs; [networkmanagerapplet];
}
