{
  fileSystems = {
    "/" = {
      device = "none";
      fsType = "tmpfs";
      options = ["mode=755" "noexec" "size=1G"];
    };
    "/boot" = {
      device = "/dev/disk/by-label/boot";
      fsType = "ext2";
      options = ["noexec"];
    };
    "/nix" = {
      device = "/dev/disk/by-label/nix";
      fsType = "ext4";
      options = ["noatime"];
    };
    "/var" = {
      device = "/dev/disk/by-label/var";
      fsType = "ext4";
      options = ["noexec"];
    };
  };

  swapDevices = [
    {
      device = "/dev/disk/by-label/swap";
    }
  ];
}
