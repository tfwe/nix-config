# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  # You can import other home-manager modules here
  imports = [
    # If you want to use modules your own flake exports (from modules/home-manager):
    # outputs.homeManagerModules.example

    # Or modules exported from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModules.default
    
    # You can also split up your configuration and import pieces of it here:
    # ./nvim.nix
    ./plasma.nix
    ./nvim.nix
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
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = _: true;
      permittedInsecurePackages = [
        "electron-25.9.0"
      ];
    };
  };

  # TODO: Set your username
  home = {
    username = "carlo";
    homeDirectory = "/home/carlo";
    packages = with pkgs; [
      vlc
      prismlauncher
      chromium
      steam
      spotify
      audacity
      gimp
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
      inputs.yuzu.packages.${pkgs.system}.early-access
      jupyter
      numix-icon-theme-circle
    #  thunderbird
    ];
  };

  # Enable home-manager and git
  programs.home-manager.enable = true;
  programs.git = {
    enable = true;
    userEmail = "carloflores953@gmail.com";
    userName = "Carlo";
    extraConfig = {
      core = {
        editor = "nvim";
      };
    };
  };
  # home.file."rclone.conf" = {
  #   target = ".config/rclone/rclone.conf";
  # };
  # systemd.user.services.drive = {
  #   Unit = {
  #     Description = "Drive (rclone)";
  #     After = [ "network.target" ];
  #   };
  #   Service = {
  #     Type = "simple";
  #     ExecStart = ''
  #     ${pkgs.rclone}/bin/rclone mount --vfs-cache-mode full Carleton: /home/carlo/Carleton/ --allow-non-empty --allow-other
  #   '';
  #     Restart = "on-failure";
  #     RestartSec = "15";
  #   };
  #   Install = {
  #     wantedBy = [ "multi-user.target" ];
  #   };
  # };
    # systemd.user.services.rclone-drive-carleton = {
    # Unit = {
    #   Description = "Service that connects to Carleton Google Drive";
    #   After = [ "network-online.target" ];
    #   Requires = [ "network-online.target" ];
    # };
    # Install = {
    #   WantedBy = [ "default.target" ];
    # };
    # 
    # Service = let
    #   gdriveDir = "/home/carlo/Carleton";
    #   in
    #   {
    #     Type = "simple";
    #     ExecStartPre = "/run/current-system/sw/bin/mkdir -p ${gdriveDir}";
    #     ExecStart = "${pkgs.rclone}/bin/rclone mount --vfs-cache-mode full Carleton: ${gdriveDir}";
    #     ExecStop = "/run/current-system/sw/bin/fusermount -u ${gdriveDir}";
    #     Restart = "on-failure";
    #     RestartSec = "10s";
    #     Environment = [ "PATH=/run/wrappers/bin/:$PATH" ];
    #   };
    # };
  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.05";
}
