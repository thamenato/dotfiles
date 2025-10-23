{backgrounds, ...}: {
  programs.swaylock = {
    enable = false;

    settings = {
      image = "${backgrounds."wallhaven-exj8pw.jpg"}";
      indicator-caps-lock = true;
      indicator-radius = 115;
      inside-color = "#2e344098";
      inside-ver-color = "#5e81ac";
      key-hl-color = "#5e81ac";
      layout-text-color = "#eceff4";
      line-color = "#3b4252";
      line-ver-color = "#5e81ac";
      line-wrong-color = "#d08770";
      ring-color = "#4c566a";
      ring-ver-color = "#5e81ac98";
      separator-color = "#4c566a";
      text-color = "#d8dee9";
    };
  };
}
