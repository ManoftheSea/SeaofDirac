{
  fileSystems = {
    "/" = {
      device = "none";
      fsType = "tmpfs";
      options = ["noatime" "size=1G" "mode=755"];
    };
    "/nix" = {
      device = "/dev/disk/by-label/nix_store";
      fsType = "ext4";
      options = ["noatime"];
    };
    "/var" = {
      device = "/dev/disk/by-label/var-usb";
      fsType = "ext4";
      options = ["relatime" "noexec"];
    };
    "/home" = {
      device = "/dev/disk/by-label/home-usb";
      fsType = "ext4";
      options = ["relatime" "noexec"];
    };
    "/efi" = {
      device = "/dev/disk/by-label/ESP-USB";
      fsType = "vfat";
      options = ["noatime" "noexec"];
    };
  };

  swapDevices = [];
}
