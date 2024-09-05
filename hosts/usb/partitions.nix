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
      "store" = {
        storePaths = [config.system.build.toplevel];
        stripNixStorePrefix = true;
        repartConfig = {
          Format = "erofs";
          Label = "store_${config.system.image.version}";
          Minimize = "off";
          ReadOnly = "yes";
          SizeMaxBytes = "4G";
          SizeMinBytes = "1G";
          SplitName = "store";
          Type = "linux-generic";
          Verity = "data";
          VerityMatchKey = "store";
        };
      };
      "store-verity".repartConfig = {
        Label = "verity_${config.system.image.version}";
        SizeMaxBytes = "512M";
        SizeMinBytes = "64M";
        Type = "linux-generic";
        Verity = "hash";
        VerityMatchKey = "store";
      };
      "store-empty".repartConfig = {
        Label = "_empty";
        Minimize = "off";
        SizeMaxBytes = "4G";
        SizeMinBytes = "1G";
        SplitName = "-";
        Type = "linux-generic";
      };
      "store-empty-verity".repartConfig = {
        SizeMaxBytes = "512M";
        SizeMinBytes = "64M";
        SplitName = "-";
        Type = "linux-generic";
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
