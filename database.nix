{ config, lib, pkgs, ... }:


{
  services.httpd = {
    enable = true;
    adminAddr = "admin@localhost";
    enablePHP = true;

  };

  services.mysql = {
    enable = true;
    package = pkgs.mariadb;
    ensureUsers = [
      {
        name = "root";
        ensurePermissions = { "*.*" = "ALL PRIVILEGES"; };
      }
    ];
  };

  services.phpmyadmin = {
    enable = true;
    router = "httpd";
  };
}