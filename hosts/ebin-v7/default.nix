{ config, lib, suites, profiles, pkgs, ... }:

{
  imports = suites.server;

  boot.loader.efi.canTouchEfiVariables = false;

  fileSystems = {
    "/" = {
      device = "none";
      fsType = "tmpfs";
      options = [ "defaults" "mode=755" ];
    };
    "/nix" = {
      device = "/dev/disk/by-label/nix_store";
      fsType = "ext4";
    };
    "/var" = {
      device = "/dev/disk/by-label/var";
      fsType = "ext4";
    };
    "/efi" = {
      device = "/dev/disk/by-label/ESP";
      fsType = "vfat";
    };
  };

  swapDevices = [
    {
      device = "/dev/disk/by-label/swap";
    }
  ];

  networking = {
    hostName = "ebin-v7";
    useNetworkd = true;
    wireless.enable = false;
    useDHCP = false;
    firewall = {
      enable = true;
      allowPing = true;
      trustedInterfaces = [ "br0" ];
      allowedTCPPorts = [
        22
      ];
      allowedUDPPorts = [ ];
    };
  };

  systemd.network = {
    enable = true;
    netdevs.br0.netdevConfig = {
      Name = "br0";
      Kind = "bridge";
    };
    networks = {
      eth0 = {
        matchConfig.Name = "eth0";
      };
      wan = {
        matchConfig.Name = "wan";
        networkConfig = {
          DHCP = "yes";
        };
      };
      lan = {
        matchConfig.Name = "lan*";
        networkConfig = {
          Bridge = "br0";
        };
      };
    };
  };

  environment = {
    noXlibs = true;
    systemPackages = with pkgs; [
      vim
      wget
    ];
  };

  hardware.enableRedistributableFirmware = true;

  services.openssh = {
    hostKeys = [
      {
        path = "/var/lib/ssh/ssh_host_key_ed25519_key";
        type = "ed25519";
      }
    ];
  };

  system.activationScripts.persistent-directories = ''
    mkdir -pm 0755 /var/lib/ssh
  '';
}
