{
  disko.devices = {
    disk = {
      nixstore = {
        type = "disk";
        device = "/dev/disk/by-id/nvme-WD_Green_SN350_1TB_24231F801812";
        content = {
          type = "gpt";
          partitions = {
            root = {
              size = "100%";
              content = {
                type = "btrfs";
                extraArgs = ["-f"];
                mountpoint = "/nix";
                mountOptions = [
                  "compress=zstd"
                  "noatime"
                ];
              };
            };
          };
        };
      };
    };
  };
}
