{
  config,
  pkgs,
  ...
}: let
  inherit (config.networking) domain fqdn;
in {
  security.acme.certs."${fqdn}".extraDomainNames = ["mta-sts.${domain}"];

  services.nginx.virtualHosts."mta-sts.${domain}" = {
    root = pkgs.writeTextDir ".well-known/mta-sts.txt" ''
      version: STSv1
      mode: enforce
      max_age: 10368000
      mx: littlecreek.seaofdirac.org
    '';
    forceSSL = true;
    useACMEHost = fqdn;
  };
}
