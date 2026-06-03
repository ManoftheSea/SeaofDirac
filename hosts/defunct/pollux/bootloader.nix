_: {
  boot = {
    loader.efi.canTouchEfiVariables = false;
    initrd.availableKernelModules = [];
    kernel.sysctl."kernel.dmesg_restrict" = false;
    kernelModules = ["coretemp"];
    #kernelPackages = pkgs.linuxPackages_latest;
  };
}
