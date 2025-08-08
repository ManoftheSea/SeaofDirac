{config, ...}: let
  inherit (config.networking) domain fqdn;
  bimiIcon = ''
    <?xml version="1.0" encoding="utf-8"?>
    <svg version="1.2" baseProfile="tiny-ps" id="Layer_1" xmlns="http://www.w3.org/2000/svg"
    xmlns:xlink="http://www.w3.org/1999/xlink" viewBox="0 0 512 512" xml:space="preserve">
    <title>Sea of Dirac</title>
    <path fill="#88E2DB" d="M0,413.249c0,0,99.571-7.286,135.999-84.999S166.356,98.751,343.641,98.751 c38.871,0,81.438,18.386,104.731,34.602c116.875,81.362,61.625,248.326-75.589,205.523c0,0,49.786-2.125,49.786-67.697 s-82.091-75.285-94.714-20.643c-8.992,38.927-3.643,156.643,167.571,162.713"/>
    <path fill="#A5F2EA" d="M372.784,338.875c42.5,0,125.678-65.875,75.213-144.378c-35.287-54.897-131.676-65.997-200.283,2.61 c-68.535,68.535-28.014,201.304-247.07,216.094c8.549-0.789,100.639-10.88,135.356-84.951 c36.429-77.714,30.357-229.499,207.642-229.499c38.869,0,81.43,18.384,104.731,34.607 C565.247,214.715,509.998,381.679,372.784,338.875z"/>
    <path fill="#C9F7F1" d="M406.626,345.468c98.15-7.286,125.848-141.731,24.747-212.111 c-21.967-15.288-61.03-32.494-97.992-34.425c3.351-0.122,6.775-0.182,10.261-0.182c38.869,0,81.43,18.384,104.731,34.607 C555.096,207.648,518.304,353.313,406.626,345.468z"/>
    <path fill="#73C6BE" d="M495.426,413.249H268.433c-25.498-10.585-35.582-47.794-21.933-103.214 c15.166-61.576,44.686-94.762,88.642-101.999c26.411-4.347,46.895,4.299,59.973,12.945c-25.087-13.418-59.464-4.238-67.259,29.556 C318.858,289.466,324.212,407.178,495.426,413.249z"/>
    </svg>
  '';
  securityTxt = ''
    Contact: mailto:security@seaofdirac.org
    Canonical: https://seaofdirac.org/.well-known/security.txt
  '';
in {
  security.acme.certs."${fqdn}".extraDomainNames = ["${domain}"];

  services.nginx.virtualHosts."${domain}" = {
    extraConfig = "add_header Strict-Transport-Security \"max-age=300;\" always;";
    forceSSL = true;
    useACMEHost = fqdn;
    locations = {
      "/.well-known/bimi/icon.svg".extraConfig = ''
        default_type image/svg+xml;
        return 200 ${builtins.toJSON bimiIcon};
      '';
      "/.well-known/security.txt".extraConfig = ''
        default_type text/plain;
        return 200 ${builtins.toJSON securityTxt};
      '';
    };
  };
}
