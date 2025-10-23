{
  pkgs,
  inputs,
  ...
}: rec {
  mkSwaybg = outputs: {
    argv =
      [
        "${pkgs.swaybg}/bin/swaybg"
        "-m"
        "fill"
      ]
      ++ (pkgs.lib.concatMap (item: [
          "-o"
          item.output
          "-i"
          "${item.image}"
        ])
        outputs);
  };

  mkReadFolder = dir: let
    fileList = builtins.readDir dir;
    mkFileAttr = name: type:
      if type == "regular"
      then "${dir}/${name}"
      else null;
  in
    pkgs.lib.filterAttrs (_name: value: value != null) (pkgs.lib.mapAttrs mkFileAttr fileList);

  mkHome = {hostName}: (inputs.home-manager.lib.homeManagerConfiguration {
    inherit pkgs;

    extraSpecialArgs = {
      inherit inputs;

      backgrounds = mkReadFolder ./misc/backgrounds;
      utils = {
        mkSwaybg = mkSwaybg;
      };
    };

    modules = [
      inputs.nixvim.homeModules.nixvim
      inputs.niri.homeModules.niri
      inputs.niri.homeModules.stylix
      inputs.stylix.homeModules.stylix
      inputs.zen-browser.homeModules.beta
      ./home-manager
      ./hosts/${hostName}
    ];
  });

  mkHomeConfigurations = username: hosts:
    builtins.listToAttrs (
      map
      (hostName: {
        name = "${username}@${hostName}";
        value = mkHome {inherit hostName;};
      })
      hosts
    );
}
