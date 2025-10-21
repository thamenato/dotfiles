{pkgs, ...}: {
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
}
