{pkgs, ...}: {
  environment.systemPackages = [pkgs.virt-manager];

  networking.firewall.trustedInterfaces = [
    "virbr0"
  ];

  virtualisation = {
    libvirtd = {
      enable = true;
      qemu = {
        swtpm.enable = true;
        vhostUserPackages = [pkgs.virtiofsd];
      };
    };
    spiceUSBRedirection.enable = true;
  };
}
