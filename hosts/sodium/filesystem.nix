{
  fileSystems = {
    "/" = {
      device = "none";
      fsType = "tmpfs";
      options = ["noatime" "size=1G" "mode=755"];
    };
    "/efi" = {
      device = "/dev/disk/by-uuid/F96A-E450";
      fsType = "vfat";
      options = ["noatime" "noexec"];
    };
    "/nix" = {
      device = "/dev/disk/by-uuid/eef95976-eb24-4aac-88ae-a8c24ca2f5ad";
      fsType = "ext4";
      options = ["noatime"];
    };
    "/var" = {
      device = "/dev/disk/by-uuid/35c49a2e-09dd-42df-ad1b-528b51ef0cc9";
      fsType = "ext4";
      options = ["relatime" "noexec"];
    };
    "/home" = {
      device = "/dev/disk/by-uuid/2f8c09c6-6cd6-4dd7-b75e-9143a0993241";
      fsType = "ext4";
      options = ["relatime" "noexec"];
    };
  };

  swapDevices = [
    {
      device = "/dev/disk/by-label/swap";
    }
  ];
}
