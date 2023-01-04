{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.vars;
in
{
  options.vars = {
    email = mkOption { type = types.str; };
    username = mkOption { type = types.str; };
    terminal = mkOption { type = types.str; };
    terminalBin = mkOption { type = types.str; };

    sshPublicKey = mkOption { type = types.str; };

    timezone = mkOption { type = types.str; };
  };
}
