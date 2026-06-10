{
  config,
  pkgs,
  lib,
  ...
}:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./packages.nix
    ./graphics.nix
    #./home-config.nix
  ];

  # Bootloader.
  #boot.loader.timeout = 0;
  #boot.loader.systemd-boot.editor = true;
  #boot.loader.systemd-boot.configurationLimit = 0;
  #boot.loader.systemd-boot.enable = true;

  boot.loader.systemd-boot.enable = false;

  # Esta opción va FUERA de GRUB, a nivel de boot.loader.efi
  boot.loader.efi.canTouchEfiVariables = true;

  # Configuración limpia de GRUB a nivel UEFI
  boot.loader.grub = {
    enable = true;
    device = "nodev";
    efiSupport = true;
    useOSProber = false;

    extraEntries = ''
      menuentry "Windows 11" --class windows --class os {
          insmod part_gpt
          insmod fat
          insmod chain

          # Forzamos a GRUB a pararse en tu partición de NixOS (FAT32)
          search --no-floppy --file --set=root /EFI/Microsoft/Boot/bootmgfw.efi

          # Lanza el cargador universal que sí tiene el mapa de tu Windows de 1.9T
          chainloader /EFI/Microsoft/Boot/bootmgfw.efi
      }
    '';
  };


  # Tiempo de espera en el menú de GRUB (10 segundos)
  boot.loader.timeout = 10;

  #boot.loader.grub = {
    #enable = true;
    #efiSupport = true;
    #devices = [ "nodev" ];
    #useOSProber = true;    # Mantiene el escaneo de tu Windows

    # ESTA ES LA CORRECCIÓN REAL:
    #efiInstallAsRemovable = true;
  #};

  # Mantén el timeout visible
  #boot.loader.timeout = 10;

  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelParams = [
    "nowatchdog"
    "preempt=full"
  ];
  boot.kernelModules = [ "ntsync" ];

  hardware.graphics = {
    enable = true;
  };

  hardware.bluetooth.enable = true; # enables support for bluetooth
  hardware.bluetooth.powerOnBoot = true; # powers up the default Bluetooth controller on boot

  networking.hostName = "1L5-Thunder-Nix"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Mexico_City";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  virtualisation.docker.enable = true;

  #virtualisation.spiceUSBRedirection.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.ale = {
    isNormalUser = true;
    description = "ale";
    extraGroups = [
      "networkmanager"
      "wheel"
      "docker"
      "dialout"
    ];
    #packages = with pkgs; [ ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  fonts.packages = with pkgs; [
    fira-code
    fira-code-symbols
    noto-fonts
    liberation_ttf
    dejavu_fonts
    font-awesome
    nerd-fonts.jetbrains-mono
  ];

  environment.etc."polkit-1/rules.d/10-nixos.rules".text = ''
    polkit.addRule(function(action, subject) {
      if (action.id == "org.freedesktop.policykit.exec" &&
          subject.isInGroup("wheel")) {
          return polkit.Result.YES;
      }
    });
  '';

  security.pam.services.swaylock = { };
  services.printing.enable = true;
  #services.printing.drivers = [ pkgs.epson-escpr2 ];
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    #openFirewall = true;
  };

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
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      kdePackages.xdg-desktop-portal-kde
      xdg-desktop-portal-gnome
    ];
  };
  # Most of this is copied from niri's config, except the KDE FileChooser
  xdg.portal.config = {
    niri = {
      default = [
        "gnome"
        "gtk"
      ];
      "org.freedesktop.impl.portal.Access" = [ "gtk" ];
      "org.freedesktop.impl.portal.Notification" = [ "gtk" ];
      "org.freedesktop.impl.portal.Secret" = [ "gnome-keyring" ];
      "org.freedesktop.impl.portal.FileChooser" = [ "kde" ];
    };
  };
  programs.dconf.enable = true;

  programs.nvf = {
    enable = true;
    settings = import ./nvf-config.nix;
  };

  services.gvfs.enable = true;
  services.flatpak.enable = true;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;
  };

  services.pipewire.wireplumber.extraConfig."10-bluez" = {
    "monitor.bluez.properties" = {
      "bluez5.enable-sbc-xq" = true;
      "bluez5.enable-msbc" = true;
      "bluez5.enable-hw-volume" = true;
      "bluez5.headset-roles" = [
        "hsp_hs"
        "hsp_ag"
        "hfp_hf"
        "hfp_ag"
      ];
    };
  };

  # Open ports in the firewall.
  #networking.firewall.allowedTCPPorts = [
  #  58396
  #  631
  #  53317
  #];
  #networking.firewall.allowedUDPPorts = [
  #  631
  #  53317
  #];

  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.11"; # Did you read the comment?
}
