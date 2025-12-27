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

    modules = with inputs; [
      # external dependencies
      niri.homeModules.niri
      niri.homeModules.stylix
      nvf.homeManagerModules.default
      stylix.homeModules.stylix
      zen-browser.homeModules.beta
      # internal
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
