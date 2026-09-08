{ pkgs, ... }:

{
  home.username = "daswosau";
  home.homeDirectory = "/home/daswosau";
  home.stateVersion = "26.05"; # Use your NixOS version string

  # Enable Home Manager to manage itself
  programs.home-manager.enable = true;
}