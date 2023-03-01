{
  fileSystems = {
    "/" = {
      device = "none";
      fsType = "tmpfs";
      options = ["noatime" "size=1G" "mode=755"];
    };
    "/efi" = {
      device = "/dev/nvme0n1p1";
      fsType = "vfat";
      options = ["noatime" "noexec"];
    };
    "/nix" = {
      device = "/dev/nvme0n1p2";
      fsType = "ext4";
      options = ["noatime"];
    };
    "/var" = {
      device = "/dev/nvme0n1p10";
      fsType = "ext4";
      options = ["relatime" "noexec"];
    };
    "/home" = {
      device = "/dev/nvme0n1p20";
      fsType = "ext4";
      options = ["relatime" "noexec"];
    };
  };

  swapDevices = [];
}
