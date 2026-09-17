{ config, lib, pkgs, ... }:

let
  phpmyadminSrc = pkgs.fetchFromGitHub {
    owner = "code-lts";
    repo = "phpmyadmin-releases";
    rev = "upstream/version/all-languages/5.2.3";
    hash = lib.fakeHash; # Futtatás után cseréld ki a valódi hash-re
  };

  phpmyadminConfig = pkgs.writeTextDir "config.inc.php" ''
    <?php
    $cfg['blowfish_secret'] = 'Nx7kQ2pLmA9sWdYr4vBhJeZ6gUfTcR3i';
    $cfg['Servers'][1]['auth_type']     = 'cookie';
    $cfg['Servers'][1]['host']          = '127.0.0.1';
    $cfg['Servers'][1]['AllowNoPassword'] = false;
    $cfg['UploadDir'] = '';
    $cfg['SaveDir']   = '';
  '';

  phpmyadmin = pkgs.symlinkJoin {
    name  = "phpmyadmin";
    paths = [ phpmyadminSrc phpmyadminConfig ];
  };
in
{
  services.httpd = {
    enable    = true;
    adminAddr = "admin@localhost";
    enablePHP = true;
    phpPackage = pkgs.php.override { ztsSupport = true; };

    virtualHosts."localhost" = {
      documentRoot = "/var/www/html";
      extraConfig = ''
        <Directory "/var/www/html">
          Options -Indexes +FollowSymLinks
          AllowOverride All
          Require all granted
        </Directory>

        Alias /phpmyadmin ${phpmyadmin}
        <Directory "${phpmyadmin}">
          DirectoryIndex index.php
          Options -Indexes +FollowSymLinks
          AllowOverride All
          Require all granted
        </Directory>
      '';
    };
  };

  services.mysql = {
    enable  = true;
    package = pkgs.mariadb;
    ensureDatabases = [ "phpmyadmin" ];
    ensureUsers = [
      {
        name = "phpmyadmin";
        ensurePermissions = {
          "phpmyadmin.*" = "ALL PRIVILEGES";
        };
      }
    ];
  };

  networking.firewall.allowedTCPPorts = [ 80 443 ];
}