{lib, ...}: {
  disko.devices = {
    disk.sda = {
      device = "/dev/disk/by-id/scsi-0QEMU_QEMU_HARDDISK_drive-scsi0-0-0-0";
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
            size = "1022M";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
              mountOptions = ["noatime" "noexec"];
            };
          };
          nix = {
            end = "39G";
            content = {
              type = "filesystem";
              format = "ext4";
              mountpoint = "/nix";
              mountOptions = ["relatime"];
            };
          };
          var = {
            end = "-4G";
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
