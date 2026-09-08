# modules/home/programs/taskwarrior.nix
{...}: {
  flake.homeModules."programs/taskwarrior" = {pkgs, ...}: {
    programs.taskwarrior = {
      package = pkgs.taskwarrior3;
      enable = true;

      config = {
        # Deadlines belong in Jira or the calendar; a wall of overdue red is what
        # makes the list unopenable. Ideas and blocked items sink below committed work.
        urgency.due.coefficient = 4.0;
        urgency.user.tag.idea.coefficient = -8.0;
        urgency.user.tag.waiting.coefficient = -4.0;
      };
    };
  };
}
