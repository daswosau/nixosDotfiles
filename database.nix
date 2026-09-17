{ config, lib, pkgs, ... }:

{
  services.httpd = {
    enable = true;
    adminAddr = "admin@localhost";
    enablePHP = true;
    phpPackage = pkgs.php;

    modules = [ "mpm_prefork" ];

    virtualHosts = {
      "localhost" = {
        documentRoot = "/var/www/html";
        locations."~ \\.php$" = {
          handler = "application/x-httpd-php";
        };
      };
    };
  };

  services.mysql = {
    enable = true;
    package = pkgs.mariadb;
    initialScript = pkgs.writeText "mariadb-init" ''
      ALTER USER 'root'@'localhost' IDENTIFIED BY '';
    '';
    ensureUsers = [
      {
        name = "phpmyadmin";
        ensurePermissions = {
          "*.*" = "ALL PRIVILEGES";
        };
      }
    ];
    ensureDatabases = [ "phpmyadmin" ];
  };

  services.phpmyadmin = {
    enable = true;
    hostName = "localhost";
  };

  networking.firewall.allowedTCPPorts = [ 80 443 ];
}