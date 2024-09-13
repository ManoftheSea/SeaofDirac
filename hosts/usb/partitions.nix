{
  config,
  pkgs,
  lib,
  ...
}: {
  image.repart = let
    inherit (pkgs.stdenv.hostPlatform) efiArch;
  in {
    inherit (config.boot.uki) name;
    seed = config.environment.etc."machine-id".text;
    split = true;

    partitions = {
      "esp" = {
        contents = {
          "/EFI/BOOT/BOOT${lib.toUpper efiArch}.EFI".source = "${pkgs.systemd}/lib/systemd/boot/efi/systemd-boot${efiArch}.efi";
          "/loader/loader.conf".source = pkgs.writeText "$out" ''
            timeout 3
          '';
        };
        repartConfig = {
          Format = "vfat";
          SizeMinBytes = "100M";
          SplitName = "-";
          Type = "esp";
        };
      };
      "xbootldr" = {
        contents."/EFI/Linux/${config.system.boot.loader.ukiFile}".source = "${config.system.build.uki}/${config.system.boot.loader.ukiFile}";
        repartConfig = {
          Format = "vfat";
          SizeMinBytes = "900M";
          SplitName = "-";
          Type = "xbootldr";
        };
      };
      "root".repartConfig = {
        Format = "ext4";
        Label = "root";
        Minimize = "off";
        ReadOnly = "no";
        SizeMaxBytes = "100M";
        SizeMinBytes = "100M";
        SplitName = "-";
        Type = "root";
      };
      "store" = {
        storePaths = [config.system.build.toplevel];
        stripNixStorePrefix = true;
        repartConfig = {
          Format = "ext4";
          Label = "store_${config.system.image.version}";
          Minimize = "off";
          ReadOnly = "no";
          SizeMaxBytes = "4G";
          SizeMinBytes = "4G";
          SplitName = "store";
          Type = "linux-generic";
        };
      };
      "var".repartConfig = {
        FactoryReset = "yes";
        Format = "ext4";
        Label = "nixos-persistent";
        Minimize = "off";
        SizeMaxBytes = "16G";
        SizeMinBytes = "5G";
        SplitName = "-";
        Type = "var";
      };
    }; # partitions
  }; # image.repart
}
