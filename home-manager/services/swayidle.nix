{pkgs, ...}: {
  services.swayidle = {
    enable = true;

    events = [
      {
        event = "before-sleep";
        command = "swaylock -fF";
      }
    ];

    timeouts = [
      {
        timeout = 300;
        command = "swaylock -fF";
      }
      {
        timeout = 600;
        command = "${pkgs.niri}/bin/niri msg action power-off-monitors";
        resumeCommand = "${pkgs.niri}/bin/niri msg action power-on-monitors";
      }
    ];
  };
}
