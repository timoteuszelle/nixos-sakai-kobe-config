# This is an example privacymask.nix file
# Copy this to privacymask.nix and fill in your own information

{
  # Personal identity information
  gitUsername = "Your Name";
  gitEmail = "your.email@example.com";
  
  # Network information
  tailscaleDomain = "your-tailnet-domain.ts.net";
  
  # Private hostnames and IPs
  privateCloudIp = "192.168.1.100";
  privateCloudHostname = "your-private-hostname.local";
}

