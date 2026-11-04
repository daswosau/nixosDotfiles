{ config, lib, pkgs, claude-desktop, rimsort, ... }:

{
    nixpkgs.config.allowUnfree = true;
	services.flatpak.enable = false;
    nix.settings.experimental-features = [ "nix-command" "flakes" ];

	environment.systemPackages = with pkgs; [
		
        #               DEVELOPMENT TOOLS, DEPENDENCIES AND LIBRARIES
 		wget curl
		unzip unrar ripgrep
		fd
		uv
		file
		git
		gcc gnumake gdb cmake
		openjdk21 scenebuilder maven libGL
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
		wineWow64Packages.full
		gnome-themes-extra

		adwaita-icon-theme
		gobject-introspection
  		gtk3
		gettext
		ffmpegthumbnailer
		glib
		ftp

		#                  TOOLS AND UTILITIES
		neovim
		nautilus-python
		(python3.withPackages (ps: with ps; [
			pygobject3
			pillow
			mutagen
		]))
		htop
		timeshift
		gparted
		gnome-tweaks
		fastfetch
		winetricks
		protontricks
		qemu
		qemu_kvm
		qemu-utils
		virtiofsd
		ollama
		avahi
			
		#                  APPLICATIONS
		brave firefox
		discord
		vlc puddletag
		lutris steam-run steamcmd
		vscode jetbrains.idea postman alpaca github-desktop virt-manager beekeeper-studio
		pinta krita upscayl davinci-resolve audacity obs-studio subtitleedit
		onlyoffice-desktopeditors obsidian foliate
		qbittorrent nicotine-plus syncthing
		mission-center gsmartcontrol

		#				  WRAPPED APPLICATIONS
		(claude-desktop.packages.${stdenv.hostPlatform.system}.claude-desktop.override {
			nodePackages = { inherit (pkgs) asar; };
		})

		(pkgs.spotify.overrideAttrs (oldAttrs: {
			postInstall = (oldAttrs.postInstall or "") + ''
			wrapProgram $out/bin/spotify --set NIXOS_OZONE_WL "0"
			'';
		}))

		rimsort.packages.${pkgs.stdenv.hostPlatform.system}.default

 	];


	programs = {
		nix-ld.enable = true;
		nix-ld.libraries = with pkgs; [
			# Add any missing dynamic libraries for unpackaged programs
			# here, NOT in environment.systemPackages
		];

		steam = {
			enable = true;
			extraCompatPackages = with pkgs; [
				proton-ge-bin
			];
		};
		localsend = {
			enable = true;
		};
		java = {
			enable = true;
			package = (pkgs.jdk21.override { enableJavaFX = true; });
		};
		fish = {
			enable = true;
		};
		virt-manager = {
			enable = true;
		};
	};

    programs.dconf.profiles.user.databases = [{
		settings = {
			"org/gnome/shell" = {
				disable-user-extensions = false;
				enabled-extensions = [
				"middle-click-expose@bitboxer.codeberg.org"
				"scroll-workspaces@gfxmonk.net"
				"dynamic-music-pill@andbal"
				"preserve-battery-health@marcosdalvarez.org"
				"Bluetooth-Battery-Meter@maniacx.github.com"
				"middleclickclose@paolo.tranquilli.gmail.com"
				"Hide_Activities@shay.shayel.org"
				"touchpad-speed-control@ritesh"
				"caffeine@patapon.info"
				"hibernate-power-menu@arnakazim"
				"active-app-indicator@morhenac"
				"appindicatorsupport@rgcjonas.gmail.com"
				"appindicator-quicksetting@vazark.github.io"
				];
			};
		};
	}];

	fonts.packages = with pkgs; [
		lato
		corefonts
		vista-fonts
	];

	virtualisation = {
		libvirtd.enable = true;
		spiceUSBRedirection.enable = true;
	};

	

}

	

	

