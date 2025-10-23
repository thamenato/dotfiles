{inputs, ...}: {
  nixGL = {
    inherit (inputs.nixGL) packages;

    defaultWrapper = "mesa";
    offloadWrapper = "nvidiaPrime";
    installScripts = ["mesa" "nvidiaPrime"];
  };
}
