# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
	imports = [ 
		./hardwareConfig/storage.nix
		./hardwareConfig/monitor.nix
		./packages.nix
		
	];

  ##		BOOTLOADER

	boot.loader.grub = {
		enable = true;
		device = "nodev";
		efiSupport = true;
		useOSProber = true;
		splashImage = ./resources/lenovoboot.png;
		timeout = 3;

	};
	boot.loader.efi.canTouchEfiVariables = true;

	boot.initrd.luks.devices."cryptlvm" = {
		device = "/dev/disk/by-uuid/cdad8d36-1102-48bd-9bbe-60a30b24b591";
		allowDiscards = true;
	};
	boot.initrd.services.lvm.enable = true;
	
	boot.resumeDevice = "/dev/vg/swap";
	boot.kernelParams = [ "resume=/dev/vg/swap" ];

  ##		NETWORKING AND LOCALE

	networking.hostName = "dwsthinkpad";
	networking.networkmanager.enable = true;

 	time.timeZone = "Europe/Budapest";

	i18n.defaultLocale = "hu_HU.UTF-8";
	i18n.extraLocaleSettings = {
		LC_ADDRESS = "hu_HU.UTF-8";
		LC_IDENTIFICATION = "hu_HU.UTF-8";
		LC_MEASUREMENT = "hu_HU.UTF-8";
		LC_MONETARY = "hu_HU.UTF-8";
		LC_NAME = "hu_HU.UTF-8";
		LC_NUMERIC = "hu_HU.UTF-8";
		LC_PAPER = "hu_HU.UTF-8";
		LC_TELEPHONE = "hu_HU.UTF-8";
		LC_TIME = "hu_HU.UTF-8";
	};

	console.keyMap = "hu";

  ##		DISPLAY MANAGEMENT

 	services.xserver.enable = true;
	services.displayManager.gdm.enable = true;
	services.desktopManager.gnome.enable = true;

 	services.xserver.xkb.layout = "hu";
	services.xserver.xkb.variant = "";
	#services.xserver.xkb.options = "eurosign:e,caps:escape";

	services.printing.enable = false;

  ##		SOUND MANAGEMENT

 	services.pulseaudio.enable = false;
 	#services.rtkit.enable = true;
 	services.pipewire = {
		enable = true;
		pulse.enable = true;
		alsa.enable = true;
		alsa.support32Bit = true;
	};

	services.libinput.enable = true;

  ##		USERS

 	users.users.daswosau = {
 		isNormalUser = true;
 		extraGroups = [ "wheel" "networkmanager" "video" "libvirtd"]; # Enable ‘sudo’ for the user
		shell = pkgs.fish;
	};


  ##		GRAPHICS DRIVERS

	hardware.graphics = {
		enable = true;
		enable32Bit = true;
	};

	services.xserver.videoDrivers = [ "nvidia" ];
	hardware.nvidia = {
		modesetting.enable = true;
		powerManagement.enable = true;
		powerManagement.finegrained = true;
		open = true;
		nvidiaSettings = true;
		package = config.boot.kernelPackages.nvidiaPackages.stable;

		prime = {
			offload.enable = true;
			offload.enableOffloadCmd = true;
			intelBusId = "PCI:0:2:0";
			nvidiaBusId = "PCI:1:0:0";
		};
	};

  ##		FINGERPRINTS

	services.fprintd.enable = true;
	security.pam.services = {
		gdm-password.fprintAuth = false;
		sudo.fprintAuth = false;        
		polkit-1.fprintAuth = false;     
	};

  ##		FILESYSTEMS
	
	environment.etc."crypttab".text = ''
		storage  /dev/disk/by-uuid/c05798f8-bdf1-4405-8532-87119d65e2f6  -  luks,discard,nofail,tpm2-device=auto,x-systemd.device-timeout=90
	'';

	fileSystems."/home/daswosau/Games" = {
		device = "/dev/disk/by-uuid/1b023262-091d-44fa-be82-b31db63d18d1";
		fsType = "ext4";
		options = [ "defaults" "nofail" ];
	};

	fileSystems."/home/daswosau/Storage" = {
		device = "/dev/mapper/storage";
		fsType = "ext4";
		options = [ "defaults" "nofail" ];
	};

  ##		ETC

	services.undervolt = {
		enable = true;
		coreOffset = -110;
	};


	

####		END OF IMPORTANT SECTION		####

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "26.05"; # Did you read the comment?

}

