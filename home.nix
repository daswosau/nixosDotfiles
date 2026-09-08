{ pkgs, ... }:

{
  home.username = "daswosau";
  home.homeDirectory = "/home/daswosau";
  home.stateVersion = "25.05"; # Use your NixOS version string
  home.enableNixpkgsReleaseCheck = false;


  # Enable Home Manager to manage itself
  programs.home-manager.enable = true;
}