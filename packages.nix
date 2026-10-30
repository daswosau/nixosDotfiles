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
		pkg-config
		ninja
		pkgconf
		cava
		zenity
		rclone
		wine
		wine64
		wineWow64Packages.full
		gnome-themes-extra
		corefonts lato
		vista-fonts
		adwaita-icon-theme
		python3
		gobject-introspection
  		gtk3
		gettext
		ffmpegthumbnailer

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
		fish
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
		(symlinkJoin {
			name = "rhythmbox-wrapped";
			paths = [ rhythmbox ];
			buildInputs = [ makeWrapper ];
			postBuild = ''
			wrapProgram $out/bin/rhythmbox \
				--prefix PYTHONPATH : "${python3.withPackages (ps: with ps; [ pygobject3 pillow mutagen ])}/${python3.sitePackages}"
			'';
		})
		
		(claude-desktop.packages.${system}.claude-desktop.override {
			nodePackages = { inherit (pkgs) asar; };
		})

		(pkgs.spotify.overrideAttrs (oldAttrs: {
			postInstall = (oldAttrs.postInstall or "") + ''
			wrapProgram $out/bin/spotify --set NIXOS_OZONE_WL "0"
			'';
		}))

		rimsort.packages.${pkgs.system}.default

 	];

	programs.nix-ld.enable = true;

	programs = {
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
				];
			};
		};
	}];

	virtualisation = {
		libvirtd.enable = true;
		spiceUSBRedirection.enable = true;
	};

	

}

	

	

