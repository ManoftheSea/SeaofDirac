{lib, ...}: {
  disko.devices.disk =
    {
      fit = {
        device = "/dev/disk/by-id/usb-Samsung_Flash_Drive_FIT_0374023030002696-0:0";
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
            nix-small = {
              size = "100%";
              content = {
                type = "filesystem";
                format = "ext4";
                mountpoint = "/nix-small";
                mountOptions = ["noatime"];
              };
            };
          };
        };
      };
    }
    // lib.genAttrs [
      "ata-ST3000DM008-2DM166_Z504NFBT"
      "ata-ST3000DM008-2DM166_Z504PKPJ"
      "ata-ST3000DM008-2DM166_Z505F8ZQ"
      "ata-ST3000DM008-2DM166_Z505HCGY"
    ] (name: {
      device = "/dev/disk/by-id/${name}";
      type = "disk";
      content = {
        type = "mdraid";
        name = "tech-raid";
      };
    });

  disko.devices.mdadm = {
    tech-raid = {
      type = "mdadm";
      level = 1;
      content = {
        type = "lvm_pv";
        vg = "tech-pool";
      };
    };
  };

  disko.devices.lvm_vg = {
    tech-pool = {
      type = "lvm_vg";
      lvs = {
        nix = {
          size = "100G";
          content = {
            type = "filesystem";
            format = "ext4";
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
    };
  };

  disko.devices.nodev."/" = {
    fsType = "tmpfs";
    mountOptions = ["size=256M" "noexec" "mode=755"];
  };
}
