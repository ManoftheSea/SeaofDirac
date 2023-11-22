{lib, ...}: {
  disko.devices.disk = {
    t500 = {
      device = "/dev/disk/by-id/nvme-CT2000T500SSD8_2336439A122B";
      type = "disk";
      content = {
        type = "gpt";
        partitions = {
          ESP = {
            type = "EF00";
            priority=1000;
            start = "1M";
            end = "1G";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/efi";
              mountOptions = ["noatime" "noexec"];
            };
          };
          public = {
            type = "8E00";
            priority=1010;
            end = "512G";
            content = {
              type = "lvm_pv";
              vg = "pubpool";
            };
          };
          private = {
            type = "8309";
            priority=1020;
            end = "1536G";
            content = {
              type = "luks";
              name = "crypt_122B";
              # integrity incompatible with discards and writes whole partition
              # extraFormatArgs = ["--integrity hmac-sha256" "--integrity-no-wipe"];
              extraOpenArgs = ["--allow-discards"];
              content = {
                type = "lvm_pv";
                vg = "privpool";
              };
            };
          };
        }; # partitions
      }; # content
    }; # t500
  }; # disk

  disko.devices.nodev = {
    "/" = {
      fsType = "tmpfs";
      mountOptions = [
        "mode=755"
        "noatime"
        "nodev"
        "noexec"
        "size=1G"
      ];
    };
  };

  disko.devices.lvm_vg = {
    pubpool = {
      type = "lvm_vg";
      lvs = {
        nix = {
          size = "50G";
          content = {
            type = "filesystem";
            format = "ext4";
            mountpoint = "/nix";
            mountOptions = ["noatime" "nodev"];
          };
        };
        # docker area
        # libvirt area
      }; # lvs
    }; # pubpool
    privpool = {
      type = "lvm_vg";
      lvs = {
        home = {
          size = "100G";
          content = {
            type = "filesystem";
            format = "ext4";
            mountpoint = "/home";
            mountOptions = ["nodev" "relatime"];
          };
        };
        var = {
          size = "10G";
          content = {
            type = "filesystem";
            format = "ext4";
            mountpoint = "/var";
            mountOptions = ["nodev" "noexec" "relatime"];
          };
        };
      }; # lvs
    }; # privpool
  }; # lvm_vg
}
