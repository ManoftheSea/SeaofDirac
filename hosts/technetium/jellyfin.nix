{
  config,
  pkgs,
  ...
}: {
  environment.systemPackages = [
    pkgs.jellyfin-web
    pkgs.jellyfin-ffmpeg
  ];

  security.acme.certs."${config.networking.fqdn}" = {
    postRun = ''
      ${pkgs.openssl}/bin/openssl pkcs12 -export -out cert.p12 -in cert.pem -inkey key.pem -passout pass:
      chown acme:nginx cert.p12
    '';
    reloadServices = [
      "jellyfin"
    ];
  };

  services.jellyfin = {
    enable = true;
    openFirewall = true;
  };

  systemd.services.jellyfin = {
    serviceConfig.LoadCredential = [
      "cert.p12:/var/lib/acme/${config.networking.fqdn}/cert.p12"
    ];
    wants = ["acme-${config.networking.fqdn}.service"];
  };
}
