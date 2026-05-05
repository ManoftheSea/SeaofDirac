{pkgs, ...}: {
  imports = [
    ./bootloader.nix
    ./disko.nix
    ./hamradio.nix
    ./network.nix
    ./prometheus.nix
    ./services.nix
    ./unfree.nix
  ];

  environment.etc."machine-id".text = "2904306768fd4a8185f3660916616816";
  # environment.systemPackages = builtins.attrValues {
  #   inherit
  #     (pkgs)
  #     dnsutils
  #     file
  #     git
  #     gptfdisk
  #     home-manager
  #     less
  #     minicom
  #     nvme-cli
  #     OVMF
  #     pciutils
  #     perl
  #     psmisc
  #     rsync
  #     strace
  #     tmux
  #     usbutils
  #     virt-manager
  #     wget
  #     ;
  #   };

  hardware = {
    intelgpu.driver = "xe";
    sane = {
      enable = true;
      extraBackends = [pkgs.hplip];
    };
    usb-modeswitch.enable = true;
  };

  programs = {
    dconf.enable = true;
    steam.enable = true;
    sway.enable = true;
  };

  security.polkit.enable = true;

  zramSwap.enable = true;
}
