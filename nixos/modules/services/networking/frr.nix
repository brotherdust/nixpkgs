{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.frr;

  services = [ 
    "bgp"
    "ospf"
    "ospf6"
    "rip"
    "ripng"
    "isis"
    "pim"
    "ldp"
    "nhrp"
    "eigrp"
    "babel"
    "sharp"
    "pbr"
    "bfd"
    "fabric"
    "vrrp"
  ];

  isEnabled = service: cfg.${service}.enable;

  daemonName = service: if service == "zebra" then service else "${service}d";

  frrOptions =
  {
    enable = mkEnableOption "FRRouting daemon";

    vtyListenAddress = mkOption {
      type = types.str;
      default = "127.0.0.1";
      description = ''
        Address to bind to for VTY interface
      '';
    };
    vtyListenPort = mkOption {
      type = types.nullOr types.int;
      default = null;
      description = ''
        TCP Port to bind to for the VTY interface.
      '';
    };
    vtyshEnable = mkOption {
      type = types.bool;
      default = true;
    };
    bgpEnable = mkOption {
      type = types.bool;
      default = true;
    };
    ospfEnable = mkOption {
      type = types.bool;
      default = true;
    };
    ripEnable = mkOption {
      type = types.bool;
      default = true;
    };
    ripngEnable = mkOption {
      type = types.bool;
      default = true;
    };
    isisEnable = mkOption {
      type = types.bool;
      default = true;
    };
    pimEnable = mkOption {
      type = types.bool;
      default = true;
    };
    ldpEnable = mkOption {
      type = types.bool;
      default = true;
    };
    nhrpEnable = mkOption {
      type = types.bool;
      default = true;
    };
    eigrpEnable = mkOption {
      type = types.bool;
      default = true;
    };
    babelEnable = mkOption {
      type = types.bool;
      default = true;
    };
    sharpEnable = mkOption {
      type = types.bool;
      default = true;
    };
    bfdEnable = mkOption {
      type = types.bool;
      default = true;
    };
    fabricEnable = mkOption {
      type = types.bool;
      default = true;
    };
    vrrpEnable = mkOption {
      type = types.bool;
      default = true;
    };
  };

  frrServiceConfig = cfg:
  {

    description = "FRRouting";
    documentation = [ "https://frrouting.readthedocs.io/en/latest/setup.html" ];
    wants = [ "network.target" ];
    after = [ "network-pre.target" "systemd-sysctl.service"];
    before = [ "network.target" ];
    # onFailure = [ "heartbeat-failed@%n.service"];

    serviceConfig = {
      Type = "forking";
      ExecStart = "@${pkgs.frr}/usr/lib/frr/frrinit.sh start";
      ExecStop = "@${pkgs.frr}/usr/lib/frr/frrinit.sh stop";
      ExecReload = "@${pkgs.frr}/usr/lib/frr/frrinit.sh reload";
      Nice = -5;
      NotifyAccess = "all";
      StartLimitInterval = "3m";
      StartLimitBurst = 3;
      TimeoutSec = "2m";
      WatchdogSec = "60s";
      RestartSec = 5;
      Restart = "on-abnormal";
      LimitNOFILE = 1024;
    };
  };

  frrDaemonsFile =
  {

  };

in

{

  options = {
    services.frr = frrOptions;
  };
  
  config = mkIf (cfg.enable) {

    # environment.systemPackages = [
    #   pkgs.frr               # for the vtysh tool
    # ];

    users.users.frr = {
      description = "FRRouting daemon user";
      isSystemUser = true;
      group = "frr";
    };

    users.groups = {
      frr = {};
      # Members of the frrvty group can use vtysh to inspect the FRRouting daemons
      frrvty = { members = [ "frr" ]; };
    };

    systemd.services.frr = frrServiceConfig cfg;
  };

  meta.maintainers = with lib.maintainers; [ brotherdust ];


}
