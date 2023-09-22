{lib, ...}: {
  disko.devices = {
    disk.vda = {
      device = "/dev/vda";
      type = "disk";
      content = {
        type = "gpt";
        partitions = {
          boot = {
            size = "1M";
            type = "EF02";
          };
          ESP = {
            type = "EF00";
            size = "127M";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/efi";
              mountOptions = ["noatime" "noexec"];
            };
          };
          nix = {
            end = "-2G";
            content = {
              type = "filesystem";
              format = "ext4";
              mountpoint = "/nix";
              mountOptions = ["relatime"];
            };
          };
          var = {
            end = "-1G";
            content = {
              type = "filesystem";
              format = "ext4";
              mountpoint = "/var";
              mountOptions = ["relatime" "noexec"];
            };
          };
          swap = {
            size = "100%";
            content.type = "swap";
          };
        };
      };
    };
    nodev."/" = {
      fsType = "tmpfs";
      mountOptions = ["size=256M" "noexec" "mode=755"];
    };
  };
}
