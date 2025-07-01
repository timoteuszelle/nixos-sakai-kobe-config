# This is an example privacymask.nix file for Sakai laptop
# Copy this to ~/.config/nixos-config/privacy/sakai.nix and fill in your own information

{
  # Personal identity information
  gitUsername = "Your Name";
  gitEmail = "your.email@example.com";
  
  # Work-related information
  gitlabUsername = "your-gitlab-username";
  gitlabEmail = "your.work@company.com";
  
  # GitHub information
  githubUsername = "your-github-username";
  githubEmail = "your.github@example.com";
  
  # Work-related paths and tokens (SENSITIVE - Keep this file secure!)
  workGitDir = "/path/to/your/work-git";
  personalGitDir = "/path/to/your/personal-git";
  
  # GitLab configuration (SENSITIVE)
  gitlabToken = "your-gitlab-token-here";
  gitlabClientCert = "/path/to/your/client.crt";
  gitlabClientKey = "/path/to/your/client.key";
  
  # Work GitLab instance
  workGitlabUrl = "https://your-work-gitlab.com";
}

