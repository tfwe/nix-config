# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:
let
  unstable = import <nixos-unstable> { config = { allowUnfree = true; }; };
in 
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./rescue_boot.nix
    ];
  
  # Use the latest kernel
  boot.kernelPackages = pkgs.linuxPackages_latest;

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
  boot.kernelModules = ["coretemp" "nct6775"];

  boot.supportedFilesystems = [ "ntfs" ];

  swapDevices = [ {
    device = "/var/lib/swapfile";
    size = 128*1024;
  } ];

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;
  networking.nameservers = [ "192.168.2.55" ];
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

  # udev rules
  services.udev.extraRules = ''
    SUBSYSTEM=="usb", ENV{DEVTYPE}=="usb_device", ATTRS{idVendor}=="057e", ATTRS{idProduct}=="0337", MODE="0666"
  '';
  #enable virtualisation
  # virtualisation.virtualbox.host.enable = true;
  # virtualisation.virtualbox.host.enableExtensionPack = true;
  # users.extraGroups.vboxusers.members = [ "carlo" ];

  # Enable the KDE Plasma Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;
  
# Enable wayland
  # programs.xwayland.enable = true;
  # services.xserver.displayManager.gdm.wayland = true;
  # environment.sessionVariables.NIXOS_OZONE_WL = "1"; # for electron apps like discord to work
  # services.xserver.displayManager.defaultSession = "plasmawayland";
  
  hardware.opengl.driSupport32Bit = true;

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
  # Configure keymap in X11
  services.xserver = {
    layout = "us";
    xkbVariant = "";
    deviceSection = ''
      #Identifier "Nvidia Card"
      #Driver "nvidia"
      Option "VirtualHeads" "3"
    '';
  };

  fonts.packages = with pkgs; [
    roboto
    ipafont
    kochi-substitute
    nerdfonts
    pretendard
  ];
  
  fonts.fontconfig.defaultFonts = {
      monospace = [
        "Agave"
        "IPAGothic"
      ];
      sansSerif = [
        "Roboto"
        "IPAPGothic"
      ];
      serif = [
        "Agave"
        "IPAPMincho"
      ];
    };

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

  # Enable touchpad support (enabled default in most desktopManager).
  services.xserver.libinput.enable = true;
  services.xserver.wacom.enable = true;
  hardware.opentabletdriver.enable = true;

  nixpkgs.config.permittedInsecurePackages = [
    "electron-25.9.0"
    "electron-19.1.9"
  ];
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.carlo = {
    isNormalUser = true;
    description = "Carlo";
    shell = pkgs.fish;
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      prismlauncher
      chromium
      steam
      spotify
      audacity
      gimp
      rclone-browser
      discord
      keepassxc
      obs-studio
      ryujinx
      libreoffice
      betterdiscordctl
      osu-lazer
      cemu
      obsidian
      pspp
      openai-whisper
      dolphin-emu
      unstable.yuzu-early-access
      jupyter
    #  thunderbird
    ];
  };

  users.users.root = {
    shell = pkgs.fish;
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  # nixpkgs.config.cudaSupport = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget

  environment.systemPackages = with pkgs; [
    
    # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    speechd
    gnuplot
    gnumake
    lm_sensors
    appimage-run
    autoconf
    automake
    neovim-unwrapped
    rclone
    libsForQt5.bismuth
    wget
    numix-icon-theme-circle
    htop
    vlc
    os-prober
    fish
    zsh
    (python3.withPackages(ps: with ps; [
      pandas
      numpy
      chess
      torch-bin
      torchvision-bin
      colorama
      matplotlib
      scipy
      tensorflowWithCuda
      keras
      ipykernel
      setuptools
    ]))
    neofetch
    sshs
    sshfs
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
    filezilla
    wineWowPackages.stable
    sqlite-web
    gh
    rar
    temurin-jre-bin
    xclip
    wl-clipboard
    ghc
    cabal2nix
    nix-prefetch-git
    cabal-install
    haskellPackages.QuickCheck
    haskellPackages.GenericPretty
    rnnoise-plugin
    easyeffects
    # cudatoolkit
    autorandr
    unstable.konsave
  ];

  environment.shells = with pkgs; [
    fish
  ];
 
  hardware.opengl.enable = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # Allow non-root users to specify the allow_other or allow_root mount options, see mount.fuse3(8).
  programs.fuse.userAllowOther = true;

  programs.fish.enable = true; #enable fish shell
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
  };

  # git options
  programs.git = {
    enable = true;
    config = {
      core.editor = "${pkgs.neovim-unwrapped}/bin/nvim";
    };
  };
  programs.java.enable = true;
  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    # require public key authentication for better security
    # settings.PasswordAuthentication = false;
    # settings.KbdInteractiveAuthentication = false;
    # settings.PermitRootLogin = "yes";
  };


  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [ 22 24872 ];
  networking.firewall.allowedUDPPorts = [ 22 24872 ];
  # Or disable the firewall altogether.
  networking.firewall.enable = true;

  nix.gc.automatic = true;
  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.11"; # Did you read the comment?

  nixpkgs.overlays = [
    # (import ./electron-overlay.nix)
    # (import ./discord-overlay.nix)
  ];
# systemd.services.fancontrol = {
#   enable = true;
#   description = "Fan control";
#   wantedBy = ["multi-user.target" "graphical.target" "rescue.target"];

#   unitConfig = {
#     Type = "simple";
#   };

#   serviceConfig = {
#     ExecStart = "${pkgs.lm_sensors}/bin/fancontrol";
#     Restart = "always";
#   };
# };
 
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    auto-optimise-store = true;
  };
  security.pam.services.kwallet = {
    name = "kwallet";
    enableKwallet = false;
  };
}
