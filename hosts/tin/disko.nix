{
  disko.devices = {
    disk.sda = {
      device = "/dev/disk/by-id/ata-PSSCN128GA87DC0_0522502044367";
      type = "disk";
      content = {
        type = "gpt";
        partitions = {
          ESP = {
            type = "EF00";
            priority = 1000;
            size = "100M";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/efi";
              mountOptions = ["noatime" "nodev" "noexec"];
            };
          };
          xbootldr = {
            type = "EA00";
            priority = 1001;
            size = "924M";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
              mountOptions = ["noatime" "nodev" "noexec"];
            };
          };
          public = {
            type = "8E00";
            priority = 1010;
            end = "-4G";
            content = {
              type = "lvm_pv";
              vg = "pubpool";
            };
          };
          swap = {
            priority = 1040;
            size = "100%";
            content.type = "swap";
          };
        };
      };
    };
    nodev."/" = {
      fsType = "tmpfs";
      mountOptions = [
        "mode=755"
        "noatime"
        "nodev"
        "noexec"
        "size=256M"
      ];
    };
    lvm_vg = {
      pubpool = {
        type = "lvm_vg";
        lvs = {
          nix = {
            size = "30G";
            content = {
              type = "filesystem";
              format = "ext4";
              mountpoint = "/nix";
              mountOptions = ["noatime" "nodev"];
            };
          };
          var = {
            size = "20G";
            content = {
              type = "filesystem";
              format = "ext4";
              mountpoint = "/var";
              mountOptions = ["nodev" "noexec" "relatime"];
            };
          };
          home = {
            size = "40G";
            content = {
              type = "filesystem";
              format = "ext4";
              mountpoint = "/home";
              mountOptions = ["nodev" "noexec" "relatime"];
            };
          };
        }; # lvs
      }; # pubpool
    }; # disko.devices
  };
}
