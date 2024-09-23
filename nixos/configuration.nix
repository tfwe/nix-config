# This is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)
{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  # You can import other NixOS modules here
  imports = [
    # If you want to use modules your own flake exports (from modules/nixos):
    # outputs.nixosModules.example

    # Or modules from other flakes (such as nixos-hardware):
    # inputs.hardware.nixosModules.common-cpu-amd
    # inputs.hardware.nixosModules.common-ssd

    # You can also split up your configuration and import pieces of it here:
    # ./users.nix

    # Import your generated (nixos-generate-config) hardware configuration
    ./hardware-configuration.nix
    # ./rescue_boot.nix
  ];

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # Add overlays your own flake exports (from overlays and pkgs dir):
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages
      # You can also add overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
      cudaSupport = true;
      permittedInsecurePackages = [
        "electron-25.9.0"
      ];
    };
  };
  # This will add each flake input as a registry
  # To make nix3 commands consistent with your flake
  nix.registry = (lib.mapAttrs (_: flake: {inherit flake;})) ((lib.filterAttrs (_: lib.isType "flake")) inputs);

  # This will additionally add your inputs to the system's legacy channels
  # Making legacy nix commands consistent as well, awesome!
  nix.nixPath = ["/etc/nix/path"];
  nix.gc.automatic = true;
  environment.etc =
    lib.mapAttrs'
    (name: value: {
      name = "nix/path/${name}";
      value.source = value.flake;
    })
    config.nix.registry;

  nix.settings = {
    # Enable flakes and new 'nix' command
    experimental-features = "nix-command flakes";
    # Deduplicate and optimize nix store
    auto-optimise-store = true;
    trusted-users = [ "root" "carlo" ];
  };  
  # FIXME: Add the rest of your current configuration
 
  # Enable networking
  networking.networkmanager.enable = true;
  # networking.nameservers = [ "192.168.2.55" ];
  hardware.bluetooth.enable = true;

  # Set your time zone.
  time.timeZone = "America/Toronto";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_CA.utf8";
  i18n.inputMethod = {
    enabled = "fcitx5";
    fcitx5.addons = with pkgs; [
      fcitx5-mozc
      fcitx5-hangul
      fcitx5-gtk
    ];
  };
  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.joycond.enable = true;

  # udev rules
  services.udev.extraRules = ''
    SUBSYSTEM=="usb", ENV{DEVTYPE}=="usb_device", ATTRS{idVendor}=="057e", ATTRS{idProduct}=="0337", MODE="0666"
  '';

  #enable virtualisation
  virtualisation.virtualbox.host.enable = true;
  # virtualisation.virtualbox.x11 = true;
  # virtualisation.virtualbox.host.enableExtensionPack = true;
  # users.extraGroups.vboxusers.members = [ "carlo" ];

  # Enable the KDE Plasma Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;
  # services.desktopManager.plasma6.enable = true;
  
  # Enable wayland
  # programs.xwayland.enable = true;
  # services.xserver.displayManager.gdm.wayland = true;
  # environment.sessionVariables.NIXOS_OZONE_WL = "1"; # for electron apps like discord to work
  # services.xserver.displayManager.defaultSession = "plasmawayland";
  hardware.opengl.enable = true;
  hardware.opengl.driSupport32Bit = true;
  hardware.opengl.setLdLibraryPath = true;
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia = {
    package = config.boot.kernelPackages.nvidiaPackages.vulkan_beta;
    # nvidiaPersistenced = true;
    modesetting.enable = true;
    prime.nvidiaBusId = "PCI:1:0:0";
    # Fix screen tearing and low refresh rate
    nvidiaSettings = true;
    forceFullCompositionPipeline = true;
  };
  # # Configure keymap in X11
  # services.xserver = {
  #   layout = "us";
  #   xkbVariant = "";
  #   deviceSection = ''
  #     #Identifier "Nvidia Card"
  #     #Driver "nvidia"
  #     Option "VirtualHeads" "3"
  #   '';
  # };

  # Enable CUPS to print documents.
  services.printing.enable = true;
  
  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };


  fonts.packages = with pkgs; [
    (nerdfonts.override { fonts = [ "Agave" ]; })
    roboto
  ];

  fonts.fontconfig = {
    defaultFonts = {
      monospace = [
        "Agave"
        "IPAGothic"
      ];
      sansSerif = [
        "Roboto"
        "IPAPGothic"
      ];
      serif = [
        "Roboto"
        "IPAPMincho"
      ];
    };
  };


  programs.fish.enable = true; #enable fish shell


  # TODO: Set your hostname
  networking.hostName = "nixpc";
 
  # Use the latest kernel
  boot.kernelPackages = pkgs.linuxPackages;

  # Bootloader.
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot";
  boot.loader.grub = {
    enable = true;
    device = "nodev";
    efiSupport = true;
    useOSProber = true;
    gfxmodeEfi = "auto";
  #  font = "/boot/grub/fonts/agave.pf2";
  };
  boot.kernelModules = ["coretemp" "nct6775" "v4l2loopback-dkms"];

  boot.supportedFilesystems = [ "ntfs" ];

  swapDevices = [ {
    device = "/var/lib/swapfile";
    size = 64*1024;
  } ];


  # TODO: Configure your system-wide user settings (groups, etc), add more users as needed.
  users.users = {
    # FIXME: Replace with your username
    carlo = {
      # TODO: You can set an initial password for your user.
      # If you do, you can skip setting a root password by passing '--no-root-passwd' to nixos-install.
      # Be sure to change it (using passwd) after rebooting!
      initialPassword = "1121";
      isNormalUser = true;
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIP1YxelAH9+KJ0QVy8vAI0D8TXQ2dq5gOwI3o8MaD1B0 carlo" #nixpc
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGhVp5UdVyPEUS8YCFjp5lJ80IA2z1FCPvEME3nkoT8o carlo" #dell xps 
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINqRqwNsWx4CsD3SJK21g1S37YsAgm4oM31KDIgDiO/t JuiceSSH" #pixel6
      ];


      # TODO: Be sure to add any other groups you need (such as networkmanager, audio, docker, etc)
      shell = pkgs.fish;
      extraGroups = [ "networkmanager" "wheel" "dialout" "adbusers" ];
    };
  };
  users.users.root = {
    shell = pkgs.fish;
  };

  # This setups a SSH server. Very important if you're setting up a headless system.
  # Feel free to remove if you don't need it.
  services.openssh = {
    enable = true;
    settings = {
      # Forbid root login through SSH.
      PermitRootLogin = "no";
      # Use keys only. Remove if you want to SSH using password (not recommended)
      PasswordAuthentication = false;
    };
  };
 # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [ 22 24872 8888 ];
  networking.firewall.allowedUDPPorts = [ 22 24872 8888 ];
  # Or disable the firewall altogether.
  networking.firewall.enable = true;

  programs.fuse.userAllowOther = true;
# RClone Google Drive service
  systemd.services.rclone-drive-carleton = {
    # Ensure the service starts after the network is up
    wantedBy = [ "multi-user.target" ];
    after = [ "network-online.target" ];
    requires = [ "network-online.target" ];

    # Service configuration
    serviceConfig = {
      Type = "simple";
      ExecStartPre = "/run/current-system/sw/bin/mkdir -p /home/carlo/Carleton/"; # Creates folder if didn't exist
      ExecStart = "${pkgs.rclone}/bin/rclone mount Carleton: /home/carlo/Carleton/ --allow-non-empty --allow-other --vfs-cache-mode full"; # Mounts
      ExecStop = "/run/current-system/sw/bin/fusermount -u /home/carlo/Carleton/"; # Dismounts
      Restart = "on-failure";
      RestartSec = "10s";
      User = "carlo";
      Group = "users";
      Environment = [ "PATH=/run/wrappers/bin/:$PATH" ]; # Required environments
    };
  };
  systemd.services.rclone-drive-home = {
    # Ensure the service starts after the network is up
    wantedBy = [ "multi-user.target" ];
    after = [ "network-online.target" ];
    requires = [ "network-online.target" ];

    # Service configuration
    serviceConfig = {
      Type = "simple";
      ExecStartPre = "/run/current-system/sw/bin/mkdir -p /home/carlo/HomeDrive/"; # Creates folder if didn't exist
      ExecStart = "${pkgs.rclone}/bin/rclone mount Home: /home/carlo/HomeDrive/ --allow-non-empty --allow-other --vfs-cache-mode full"; # Mounts
      ExecStop = "/run/current-system/sw/bin/fusermount -u /home/carlo/HomeDrive/"; # Dismounts
      Restart = "on-failure";
      RestartSec = "10s";
      User = "carlo";
      Group = "users";
      Environment = [ "PATH=/run/wrappers/bin/:$PATH" ]; # Required environments
    };
  };

  # systemd.services.drive = {
  #   description = "Drive (rclone)";
  #   after = [ "network.target" ];
  #   wants = [ "network.target" ];
  #   wantedBy = [ "multi-user.target" ];
  #   serviceConfig = {
  #     Type = "simple";
  #     User = "carlo";
  #     ExecStart = ''
  #     ${pkgs.rclone}/bin/rclone mount --vfs-cache-mode full Carleton: /home/carlo/Carleton/ --allow-non-empty --allow-other
  #   '';
  #     ExecStop = "${pkgs.coreutils}/bin/fusermount -u /home/carlo/Carleton/";
  #     Restart = "on-failure";
  #     RestartSec = "5";
  #   };
  # };
  environment.systemPackages = with pkgs; [
    
    # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    gnuplot
    gnumake
    lm_sensors
    autoconf
    automake
    libsForQt5.bismuth
    wget
    htop
    os-prober
    zsh
    gcc
    cargo
    nodejs
    gparted
    grub2
    firefox
    p7zip
    pciutils
    unzip
    archiver
    ark
    winetricks
    gpp
    gcc
    # filezilla
    wineWowPackages.stable
    sqlite-web
    gh
    rar
    wl-clipboard
    ghc
    nix-prefetch-git
    # autorandr
    fuse
    cachix
    rclone

    # (python3.withPackages (
    #   ps:
    #   with ps; [
    #     matplotlib
    #     pandas
    #     numpy
    #     scikit-learn
    #     scipy
    #     tensorflowWithCuda
    #     keras
    #     opencv
    #   ])
    # )
    #  thunderbird


  ];
  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "23.05";
}
