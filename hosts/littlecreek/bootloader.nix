{
  boot.initrd.availableKernelModules = [
    "ata_piix"
    "virtio_blk"
    "virtio_pci"
    "virtio_scsi"
    "xhci_pci"
  ];
  boot.loader.grub = {
    device = "/dev/vda";
    enable = true;
  };
}
