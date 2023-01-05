{ config, lib, ... }:

{
  system.stateVersion = lib.mkDefault "22.11";
  time.timeZone = lib.mkDefault "America/New_York";
}

