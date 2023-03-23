{
  boot.loader.efi.canTouchEfiVariables = false;

  fileSystems = {
    "/" = {
      device = "none";
      fsType = "tmpfs";
      options = ["defaults" "mode=755" "noexec"];
    };
    "/efi" = {
      device = "/dev/disk/by-label/ESP";
      fsType = "vfat";
      options = ["noexec"];
    };
    "/nix" = {
      device = "/dev/disk/by-label/nix_store";
      fsType = "ext4";
    };
    "/srv/disk" = {
      device = "/dev/sda2";
      fsType = "ext4";
      options = ["noexec"];
    };
    "/var" = {
      device = "/dev/disk/by-label/var";
      fsType = "ext4";
      options = ["noexec"];
    };
    "/var/lib/nextcloud" = {
      device = "/srv/disk/nextcloud";
      options = ["bind"];
    };
  };

  swapDevices = [
    {
      device = "/dev/disk/by-label/swap";
    }
  ];
}
