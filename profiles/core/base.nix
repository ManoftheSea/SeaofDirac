{ config, lib, pkgs, ... }:

{
  system.stateVersion = lib.mkDefault "22.11";
  time.timeZone = lib.mkDefault "America/New_York";
}

