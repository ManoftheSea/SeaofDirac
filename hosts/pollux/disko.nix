_: {
  disko.devices = {
    disk = {
      SD = {
        device = "/dev/mmcblk1";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              type = "EF00";
              priority = 1000;
              start = "1M";
              end = "512M";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/efi";
                mountOptions = ["noatime" "noexec"];
              };
            };
            swap = {
              priority = 2000;
              end = "4G";
              content = {
                type = "swap";
                discardPolicy = "both";
              };
            };
            nix = {
              priority = 3000;
              size = "12G";
              content = {
                type = "filesystem";
                format = "f2fs";
                mountpoint = "/nix";
                mountOptions = ["noatime" "nodev"];
              };
            };
            var = {
              priority = 4000;
              size = "100%";
              content = {
                type = "filesystem";
                format = "ext4";
                mountpoint = "/var";
                mountOptions = ["nodev" "noexec" "relatime"];
              };
            };
          };
        }; #partitions
      }; #SD
    }; #disk

    # Impermanence
    nodev."/" = {
      fsType = "tmpfs";
      mountOptions = [
        "mode=755"
        "noatime"
        "nodev"
        "noexec"
        "size=128M"
      ];
    };
  };
}
