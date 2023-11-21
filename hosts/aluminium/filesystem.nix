{
  fileSystems = {
    "/" = {
      device = "none";
      fsType = "tmpfs";
      options = ["noatime" "size=1G" "mode=755"];
    };
    "/efi" = {
      device = "/dev/disk/by-uuid/9E84-0C07";
      fsType = "vfat";
      options = ["noatime" "noexec"];
    };
    "/nix" = {
      device = "/dev/disk/by-uuid/47256737-ca91-4761-a302-239abdab1cc9";
      fsType = "ext4";
      options = ["noatime"];
    };
    "/var" = {
      device = "/dev/disk/by-uuid/16501ea0-1132-40cf-af0d-75fefa4b7935";
      fsType = "ext4";
      options = ["relatime" "noexec"];
    };
    "/home" = {
      device = "/dev/disk/by-uuid/aed4839a-9a15-4c03-864c-a40895ab8045";
      fsType = "ext4";
      options = ["relatime" "noexec"];
    };
  };

  swapDevices = [];
}
