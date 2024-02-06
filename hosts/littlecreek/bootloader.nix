{
  config,
  pkgs,
  ...
}: {
  boot.initrd.availableKernelModules = [
    "ata_piix"
    "virtio_pci"
    "virtio_scsi"
    "xhci_pci"
  ];
  boot.loader.grub = {
    enable = true;
    device = "/dev/vda";
  };
}
