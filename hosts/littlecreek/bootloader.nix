{
  boot.initrd.availableKernelModules = [
    "ata_piix"
    "virtio_pci"
    "virtio_scsi"
    "xhci_pci"
  ];
  boot.loader.grub = {
    device = "/dev/sda";
    enable = true;
  };
}
