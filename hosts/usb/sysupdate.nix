{config, ...}: {
  systemd.sysupdate = {
    enable = true;
    transfers = {
      "10-uki" = {
        Source = {
          MatchPattern = ["${config.boot.uki.name}_@v.efi.xz"];
          Path = "/var/updates/";
          Type = "regular-file";
        };
        Target = {
          InstancesMax = 4;
          MatchPattern = ["${config.boot.uki.name}_@v.efi"];
          Mode = "0444";
          Path = "/Linux";
          PathRelativeTo = "boot";
          Type = "regular-file";
        };
        Transfer.ProtectVersion = "%A";
      };
      "20-store" = {
        Source = {
          MatchPattern = ["store_@v.img.xz"];
          Path = "/var/updates/";
          Type = "regular-file";
        };
        Target = {
          InstancesMax = 4;
          MatchPattern = "store_@v";
          Path = "/dev/disk/by-id/usb-USB_SanDisk_3.2Gen1_01010ea463dc2da5062cab1fc26c4775956f81101f72474b9d8d62194fd5d88f4d5200000000000000000000eef3140700195300815581076f2e3920-0:0";
          ReadOnly = "yes";
          Type = "partition";
        };
      };
    };
  };
}
