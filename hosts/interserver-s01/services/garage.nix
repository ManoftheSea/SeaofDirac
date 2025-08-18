{
  config,
  pkgs,
  ...
}: {
  # networking.firewall.allowedTCPPorts = [3900];

  services.garage = {
    enable = true;
    environmentFile = config.sops.secrets.garage-env.path;
    package = pkgs.garage_1_x;
    settings = {
      admin.api_bind_addr = "[::1]:3903";
      replication_factor = 1;
      rpc_bind_addr = "[::]:3901";
      rpc_public_addr_subnet = "2601:5cd:c100:3940::/64";
      s3_api = {
        api_bind_addr = "[::]:3900";
        s3_region = "us-east-1";
      };
    };
  };

  sops.secrets.garage-env = {};
}
