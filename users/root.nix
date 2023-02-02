{
  config,
  pkgs,
  ...
}: {
  users.users.root = {
    initialHashedPassword = "$y$j9T$Fxria.3Ik92O6AxG1YKaE/$TA2bgiNBW1Bw2GWmihHzXI/wIKkVX7CIR88yG8HCL3B";
    home = "/root";

    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAQjiOPTrTj3EUfLI0DwzFRTSDboiaznFKRsiovuSS76 derek@aluminium"
    ];
  };
}
