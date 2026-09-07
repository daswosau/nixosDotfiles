{ config, lib, pkgs, ... }:

{
    nixpkgs.config.allowUnfree = true;
	services.flatpak.enable = false;
    nix.settings.experimental-features = [ "nix-command" "flakes" ];

	environment.systemPackages = with pkgs; [
		
        #               DEVELOPMENT TOOLS, DEPENDENCIES AND LIBRARIES
 		wget curl
		unzip
		unrar
		ripgrep
		fd
		uv
		file
		git
		gcc
		gnumake
		gdb
		openjdk21
		scenebuilder
		maven
		libGL
		docker
		glibc
		openssl
		nodejs
		pnpm
		pciutils
		xrandr
		meson
		ninja
		pkgconf
		cava
		zenity
		rclone
		wine
		wine64
		wineWow64Packages.full
		gnome-themes-extra
		corefonts
		vista-fonts
		python3

		#                  TOOLS AND UTILITIES
		neovim
		htop
		timeshift
		gparted
		gnome-tweaks
		fish
		fastfetch
		winetricks
		protontricks
		qemu
		qemu_kvm
		qemu-utils
		qemu-guest-agent
		virt-manager
		virt-viewern
			
		#                  APPLICATIONS
		brave
		firefox
		discord
		spotify
		steam
		vlc
		vscode
		jetbrains.idea
		pinta
		krita
		obsidian
		upscayl
		onlyoffice-desktopeditors
		lutris
		qbittorrent
		obs-studio
		mission-center
		signal-desktop
		session-desktop
		strawberry
		foliate
		audacity
		nicotine-plus
		claude-desktop
		github-desktop
		davinci-resolve

 	];

    programs.dconf.profiles.user.databases = [{
		settings = {
			"org/gnome/shell" = {
				disable-user-extensions = false;
				enabled-extensions = [
				"middle-click-expose@bitboxer.codeberg.org"
				"middleclickclose@paolo.tranquilli.gmail.com"
				"right-click-next@derVedro"
				"scroll-workspaces@gfxmonk.net"
				"dynamic-music-pill@andbal"
				"preserve-battery-health@marcosdalvarez.org"
				"Bluetooth-Battery-Meter@maniacx.github.com"
				"hibernate-power-menu@arnakazim"
				#"places-menu@gnome-shell-extensions.gcampax.github.com"
				];
			};
		};
	}];

	programs.steam = {
		enable = true;
		extraCompatPackages = with pkgs; [
			proton-ge-bin
		];
	};

	programs.java = {
		enable = true;
		package = (pkgs.jdk21.override { enableJavaFX = true; });
	};

    programs.fish = {
        enable = true;
    };

}

	

	

