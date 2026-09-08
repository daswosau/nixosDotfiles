{ pkgs, ... }:

{
    home.username = "daswosau";
    home.homeDirectory = "/home/daswosau";
    home.stateVersion = "26.05";
    home.enableNixpkgsReleaseCheck = false;
    programs.home-manager.enable = true;

    programs.fish = {
        enable = true;
        shellAliases = {

            rebuild = "nix-make";
            nix-make = "sudo nixos-rebuild switch --flake ~/Scripts/NixOS/#dwsthinkpad";
            nix-edit = "code -n ~/Scripts/NixOS";

        };

    interactiveShellInit = ''
        set -g fish_greeting "" # Disables the default Fish welcome message
        '';
    };


    dconf.settings = {
        "org/gnome/desktop/interface" = {
            color-scheme = "prefer-dark";
            enable-hot-corners = true;
            show-battery-percentage = false;
        };

        "org/gnome/desktop/peripherals/touchpad" = {
            tap-to-click = true;
            natural-scroll = false;
        };

        "org/gnome/shell" = {
            favorite-apps = [
                "brave-browser.desktop"
                "steam.desktop"
                "discord.desktop"
                "spotify.desktop"
                "net.lutris.Lutris.desktop"
                "org.gnome.Nautilus.desktop"
                "org.gnome.TextEditor.desktop"
                "obsidian.desktop"
                "claude.desktop"
                "code.desktop"
                "idea.desktop"
                "github-desktop.desktop"
                "org.gnome.Console.desktop"
            ];

        };
    };
}