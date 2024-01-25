{
  services.kea.dhcp6 = {
    enable = true;
    settings = {
      # control-socket = { };
      # hosts-database = {
      #   type = "postgresql";
      #   name = "kea";
      #   host = "/run/postgresql";
      #   user = "kea";
      # };
      # lease-database = {
      #   type = "postgresql";
      #   name = "kea";
      #   host = "/run/postgresql";
      #   user = "kea";
      # };
      # lease-database {
      #   type = "memfile";
      # };
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
          id = 80;
          subnet = "2601:5cd:c100:3940::/64";
        }
        {
          id = 81;
          subnet = "2601:5cd:c100:3941::/64";
        }
        {
          ddns-qualifying-suffix = "users.seaofdirac.org";
          id = 82;
          subnet = "2601:5cd:c100:3942::/64";
        }
        {
          id = 83;
          subnet = "2601:5cd:c100:3943::/64";
        }
      ];
    };
  };
}
