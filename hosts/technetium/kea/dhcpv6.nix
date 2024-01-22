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
      interfaces-config.interfaces = ["enp4s0f0/2601:5cd:c100:3940::10"];
      option-data = [
        {
          name = "dns-servers";
          data = "2601:5cd:c100:3940::5";
        }
        {
          name = "domain-search";
          data = "seaofdirac.org";
        }
        {
          name = "unicast";
          data = "2601:5cd:c100:3940::10";
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
