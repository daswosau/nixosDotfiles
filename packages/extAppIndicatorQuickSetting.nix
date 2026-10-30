{ pkgs, ... }:

let
  appindicator-quicksetting = pkgs.stdenv.mkDerivation {
    pname = "gnome-shell-extension-appindicator-quicksetting";
    version = "unstable-2026"; # Or exact git tag

    src = pkgs.fetchFromGitHub {
      owner = "VaZark";
      repo = "appindicator-quicksetting";
      rev = "main";
      hash = pkgs.lib.fakeHash; # Replace after first build attempt
    };

    # The extension needs gnome-shell schemas / gettext if it compiles translations,
    # but for simple extension copying:
    installPhase = ''
      runHook preInstall
      mkdir -p $out/share/gnome-shell/extensions/appindicator-quicksetting@vazark.github.com
      cp -r * $out/share/gnome-shell/extensions/appindicator-quicksetting@vazark.github.com/
      runHook postInstall
    '';
  };
in
{
  environment.systemPackages = [
    appindicator-quicksetting
  ];

  # Don't forget to enable it in dconf as well!
}