_: {
  disko.devices = {
    disk.nvme = {
      device = "/dev/disk/by-id/nvme-GOFATOO_512GB_SSD_CN41AAC6302879";
      type = "disk";
      content = {
        type = "gpt";
        partitions = {
          ESP = {
            type = "EF00";
            start = "1M";
            end = "1G";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/efi";
              mountOptions = ["relatime" "noexec"];
            };
          };
          lvpool = {
            size = "100%";
            content = {
              type = "lvm_pv";
              vg = "pool";
            };
          };
        };
      };
    };

    lvm_vg = {
      pool = {
        type = "lvm_vg";
        lvs = {
          nix = {
            size = "100G";
            content = {
              type = "filesystem";
              format = "f2fs";
              mountpoint = "/nix";
              mountOptions = ["noatime"];
            };
          };
          swap = {
            size = "32G";
            content.type = "swap";
          };
          var = {
            size = "10G";
            content = {
              type = "filesystem";
              format = "ext4";
              mountpoint = "/var";
              mountOptions = ["relatime" "noexec"];
            };
          };
          var-log = {
            size = "10G";
            content = {
              type = "filesystem";
              format = "ext4";
              mountpoint = "/var/log";
              mountOptions = ["relatime" "noexec"];
            };
          };
        };
      }; # end lv pool
    };

    nodev."/" = {
      fsType = "tmpfs";
      mountOptions = ["size=256M" "noexec" "mode=755"];
    };
  };
}
