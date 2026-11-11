{
  programs.ssh = {
    enable = true;
    # The built-in defaults are deprecated and warn at 26.05.
    enableDefaultConfig = false;
    settings = {
      homeserver = {
        User = "user";
        StrictHostKeyChecking = "accept-new";
      };
      homeserver-git = {
        HostName = "homeserver";
        User = "git";
        StrictHostKeyChecking = "accept-new";
      };
    };
  };
}
