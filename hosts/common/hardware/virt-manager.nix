{pkgs, ...}: {
  environment.systemPackages = [pkgs.virt-manager];

  virtualisation = {
    libvirtd = {
      enable = true;
      qemu.swtpm.enable = true;
    };
    spiceUSBRedirection.enable = true;
  };
}
