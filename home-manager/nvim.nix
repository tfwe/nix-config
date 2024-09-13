{ config, pkgs, lib, ... }:

let
  # Import the unstable channel with sha256 and system
  unstable = import (fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz";
    sha256 = "12c9gz8agsajy6gbaj8m7r69d485pmccjnzgwz0szv6iys6kf812"; # Replace with actual sha256
  }) {
    inherit (pkgs) system;
    config = config.nixpkgs.config or {};
  };
  nvchad-starter = pkgs.stdenv.mkDerivation {
    pname = "nvchad-starter";
    version = "2023-06-22"; # You can keep this date or update as needed

    src = pkgs.fetchgit {
      url = "https://github.com/tfwe/nvchad-starter";
      hash = "sha256-Av0yO+tFzlQiZSIzSw5Zj9C/BDXuHpvJ6D0b1Gu2gzw=";
    };

    dontBuild = true;

    installPhase = ''
      mkdir -p $out
      cp -r ./* $out/
    '';
  };
in
{
  nixpkgs.config = {
    # Add any nixpkgs configuration here if needed
    # For example:
    # allowUnfree = true;
  };

  home.activation = {
    removeExistingNvimConfig = lib.hm.dag.entryBefore ["checkLinkTargets"] ''
      $DRY_RUN_CMD rm -rf $VERBOSE_ARG ~/.config/nvim ~/.local/share/nvim
    '';
  };

  programs.neovim = {
    enable = true;
    package = unstable.neovim-unwrapped; # Use the unstable version of NeoVim
    viAlias = true;
    vimAlias = true;
    defaultEditor = true;
    extraPackages = with pkgs; [
      unzip
      python3
      nodejs
      gcc
      gnumake
      xclip
    ];
  };

  xdg.configFile.nvim = {
    source = nvchad-starter.src;
    recursive = true;
  };
}
