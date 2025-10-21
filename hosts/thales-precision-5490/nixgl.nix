{nixGL, ...}: {
  nixGL = {
    inherit (nixGL) packages;

    defaultWrapper = "mesa";
    offloadWrapper = "nvidiaPrime";
    installScripts = ["mesa" "nvidiaPrime"];
  };
}
