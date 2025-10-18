{
  programs.zen-browser = {
    enable = true;
    profiles."default" = {
      containersForce = true;
      containers = {
        "Personal" = {
          color = "purple";
          icon = "fingerprint";
          id = 1;
        };
      };
    };
  };
}
