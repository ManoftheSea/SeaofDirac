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
      "Z504NFBT"
      "Z504PKPJ"
      "Z505F8ZQ"
      "Z505HCGY"
    ] (name: {
      device = "/dev/disk/by-id/ata-ST3000DM008-2DM166_${name}";
      type = "disk";
      content = {
        type = "gpt";
        partitions = {
          ESP = {
            type = "EF00";
            end = "128M";
            content = {
              type = "filesystem";
              format = "vfat";
            };
          };
          lv_member = {
            size = "100%";
            content = {
              type = "lvm_pv";
              vg = "raidpool";
            };
          };
        };
      };
    });

  disko.devices.lvm_vg = {
    raidpool = {
      type = "lvm_vg";
      lvs = {
        nix = {
          size = "100G";
          lvm_type = "raid1";
          extraArgs = [
            "-m 3"
            "--raidintegrity y"
          ];
          content = {
            type = "filesystem";
            format = "ext4";
            mountpoint = "/nix";
            mountOptions = ["noatime"];
          };
        };
        swap = {
          size = "32G";
          lvm_type = "raid0";
          extraArgs = ["-i4"];
          content.type = "swap";
        };
        var = {
          size = "10G";
          lvm_type = "raid1";
          extraArgs = [
            "-m 3"
            "--raidintegrity y"
          ];
          content = {
            type = "filesystem";
            format = "ext4";
            mountpoint = "/var";
            mountOptions = ["relatime" "noexec"];
          };
        };
        var-log = {
          size = "10G";
          lvm_type = "raid1";
          extraArgs = [
            "-m 3"
            "--raidintegrity y"
          ];
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
