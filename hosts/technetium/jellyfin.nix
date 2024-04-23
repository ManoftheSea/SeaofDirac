{
  config,
  pkgs,
  ...
}: {
  environment.systemPackages = [
    pkgs.jellyfin-web
    pkgs.jellyfin-ffmpeg
  ];

  services.jellyfin = {
    enable = true;
    openFirewall = true;
  };

  systemd.services.jellyfin = {
    serviceConfig.LoadCredential = [
      "full.pem:/var/lib/acme/${config.networking.hostName}.seaofdirac.org/full.pem"
      "cert.pem:/var/lib/acme/${config.networking.hostName}.seaofdirac.org/cert.pem"
      "key.pem:/var/lib/acme/${config.networking.hostName}.seaofdirac.org/key.pem"
    ];
    wants = ["acme-${config.networking.hostName}.seaofdirac.org.service"];
  };
}
