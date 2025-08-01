{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (config.networking) domain fqdn;
  wellKnownPkg = pkgs.stdenv.mkDerivation {
    name = ".well-known";
    src = lib.fileset.toSource {
      root = ./well-known;
      fileset = ./well-known/.;
    };
    postInstall = ''
      mkdir $out
      cp -rv bimi matrix security.txt $out
    '';
  };
in {
  security.acme.certs."${fqdn}".extraDomainNames = ["${domain}"];

  services.nginx.virtualHosts."${domain}" = {
    locations."/.well-known/".alias = "${wellKnownPkg}/";
    forceSSL = true;
    useACMEHost = fqdn;
  };
}
