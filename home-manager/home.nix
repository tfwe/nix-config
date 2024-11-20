# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  unstable,
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

  # TODO: Set your username
  home = {
    username = "carlo";
    homeDirectory = "/home/carlo";
    packages = with pkgs; [
      vlc
      zsh
      prismlauncher
      chromium
      steam
      spotify
      audacity
      gimp
      (unstable.discord.override {
        # remove any overrides that you don't want
        withOpenASAR = true;
        withVencord = true;
      })
      unstable.vesktop
      # vesktop
      keepassxc
      obs-studio
      libreoffice
      osu-lazer
      dolphin-emu
      inputs.yuzu.packages.${pkgs.system}.suyu
      jupyter
      numix-icon-theme-circle
      easyeffects
      devenv
      kdePackages.plasma-pa
      xwaylandvideobridge
    ];
  };

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

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.05";
}
