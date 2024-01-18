{
  disko.devices = {
    disk.emmc = {
      device = "/dev/mmcblk0";
      type = "disk";
      content = {
        type = "gpt";
        partitions = {
          ESP = {
            type = "EF00";
            priority = 1000;
            size = "511M";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/efi";
              mountOptions = ["noatime" "noexec"];
            };
          };
          nix = {
            end = "11G";
            priority = 1010;
            content = {
              type = "filesystem";
              format = "ext4";
              mountpoint = "/nix";
              mountOptions = ["noatime" "nodev"];
            };
          };
          var = {
            end = "13G";
            priority = 1020;
            content = {
              type = "filesystem";
              format = "ext4";
              mountpoint = "/var";
              mountOptions = ["noexec" "relatime"];
            };
          };
          home = {
            end = "14G";
            priority = 1030;
            content = {
              type = "filesystem";
              format = "ext4";
              mountpoint = "/home";
              mountOptions = ["nodev" "relatime"];
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
  };
}
