{
  virtualisation = {
    docker = {
      enable = true;
      daemon.settings = {
        experimental = true;
        features = {
          containerd-snapshotter = true;
          buildkit = true;
        };
      };
    };
  };
}
