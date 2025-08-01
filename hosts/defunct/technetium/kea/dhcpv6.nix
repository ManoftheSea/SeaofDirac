{
  services.kea.dhcp6 = {
    enable = true;
    settings = {
      # control-socket = {};
      hosts-database = {
        type = "postgresql";
        name = "kea";
        host = "/run/postgresql";
        user = "kea";
      };
      lease-database.type = "memfile";
      /*
      lease-database = {
        type = "postgresql";
        name = "kea";
        host = "/run/postgresql";
        user = "kea";
      };
      */
      /*
      client-classes = [
        {
          name = "ipxe_efi_amd64";
          test = "option[61].hex == 0x0009"; #x86_64
          next-server = "192.168.200.10";
          boot-file-name = "/bootloaders/netboot.xyz.kpxe";
          only-if-required = true;
        }
        {
          name = "ipxe_efi_arm64";
          test = "option[61].hex == 0x000b"; #ARM64
          next-server = "192.168.200.10";
          boot-file-name = "/bootloaders/netboot.xyz-arm64.efi";
          only-if-required = true;
        }
        {
          name = "http_efi_amd64";
          test = "option[61].hex == 0x0010"; #x86_64
          boot-file-name = "http://technetium.seaofdirac.org/bootloaders/netboot.xyz.efi";
          only-if-required = true;
        }
        {
          name = "http_efi_arm64";
          test = "option[61].hex == 0x0013"; #ARM64
          boot-file-name = "http://technetium.seaofdirac.org/bootloaders/netboot.xyz-arm64.efi";
          only-if-required = true;
        }
      ];
      */
      dhcp-ddns.enable-updates = true;
      ddns-override-client-update = true;
      interfaces-config.interfaces = ["enp4s0f0/2601:5cd:c100:3940::10"];
      option-data = [
        {
          # code = 12;
          name = "unicast";
          data = "2601:5cd:c100:3940::10";
        }
        {
          # code = 23;
          name = "dns-servers";
          data = "2601:5cd:c100:3940::5";
        }
        {
          # code = 24;
          name = "domain-search";
          data = "seaofdirac.org";
        }
        {
          # code = 41;
          name = "new-posix-timezone";
          data = "EST5EDT4,M3.2.0/01:00:00,M11.1.0/02:00:00";
        }
        {
          # code = 42;
          name = "new-tzdb-timezone";
          data = "America/New_York";
        }
      ];
      subnet6 = [
        {
          id = 200;
          subnet = "2601:5cd:c100:3940::/64";
        }
        {
          id = 101;
          ddns-qualifying-suffix = "users.seaofdirac.org";
          # interface-id from ICX6250 appears to be:
          # 2 bytes VLAN id, 1 byte ethernet port? 1 byte unknown
          # 00 65 21 02 (or 101, 33, 2) for dhcp on VLAN 101
          # interface-id = "ve 101";
          subnet = "2601:5cd:c100:3942::/64";
        }
        {
          id = 205;
          subnet = "fd50:63ed:f2b7:1cd::/64";
        }
      ];
    };
  };
}
