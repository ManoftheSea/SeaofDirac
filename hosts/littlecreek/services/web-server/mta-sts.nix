{
  config,
  pkgs,
  ...
}: let
  inherit (config.networking) domain fqdn;
  mta-sts = ''
    version: STSv1
    mode: enforce
    max_age: 10368000
    mx: littlecreek.seaofdirac.org
  '';
in {
  security.acme.certs."${fqdn}".extraDomainNames = ["mta-sts.${domain}"];

  services.nginx.virtualHosts."mta-sts.${domain}" = {
    forceSSL = true;
    locations."= /.well-known/mta-sts.txt".extraConfig = ''
      default_type text/plain;
      return 200 ${pkgs.lib.strings.toJSON mta-sts};
    '';
    useACMEHost = fqdn;
  };
}
