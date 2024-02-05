{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./bootloader.nix
    ./disko.nix
    ./network.nix
    ./services.nix
  ];

  hardware = {
    cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

    sane = {
      enable = true;
      extraBackends = [pkgs.hplip];
    };
    usb-modeswitch.enable = true;
  };

  environment = {
    etc = {
      "machine-id".text = "3e33904cbe2e6c3afdfbbb94b0f99a4a";
    };
    systemPackages = builtins.attrValues {
      inherit
        (pkgs)
        dnsutils
        file
        git
        gptfdisk
        home-manager
        less
        minicom
        pciutils
        perl
        psmisc
        rsync
        strace
        tmux
        unar
        usbutils
        vlc
        vim
        virt-manager
        wget
        ;
    };
  };

  programs = {
    dconf.enable = true;
  };

  security.polkit.enable = true;

  sops = {
    defaultSopsFile = ./secrets.yaml;
    age.sshKeyPaths = ["/var/lib/ssh/ssh_host_ed25519_key"];
    secrets.sssd_envfile = {};
  };

  system.stateVersion = "23.11";

  virtualisation.libvirtd.enable = true;
  virtualisation.spiceUSBRedirection.enable = true;
  virtualisation.docker.enable = true;

  zramSwap.enable = true;
  # zramSwap.memoryPercent = 50;
}
