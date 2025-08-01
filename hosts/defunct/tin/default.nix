{pkgs, ...}: {
  imports = [
    ./bootloader.nix
    ./disko.nix
    ./network.nix
    ./services.nix
    ./unfree.nix
  ];

  hardware = {
    sane = {
      enable = true;
      extraBackends = [pkgs.hplip];
    };
    usb-modeswitch.enable = true;
  };

  environment = {
    etc = {
      "machine-id".text = "626f456afb3d411494d09b4c50035f48";
    };
    systemPackages = builtins.attrValues {
      inherit
        (pkgs)
        dnsutils
        factorio
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
    steam.enable = true;
  };

  security.polkit.enable = true;

  sops = {
    defaultSopsFile = ./secrets.yaml;
    age.sshKeyPaths = ["/var/lib/ssh/ssh_host_ed25519_key"];
  };

  system.stateVersion = "24.05";

  zramSwap.enable = true;
  # zramSwap.memoryPercent = 50;
}
