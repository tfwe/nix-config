{ pkgs, ... }:
let
  # TODO: slim down size
  netboot = import (pkgs.path + "/nixos/lib/eval-config.nix") {
    inherit (pkgs) system;
    modules = [
      (pkgs.path + "/nixos/modules/installer/netboot/netboot-minimal.nix")
      module
    ];
  };
  module = {
    system.stateVersion = "22.11";
    boot.supportedFilesystems = [ "btrfs" "ext4" ];
    environment.systemPackages = with pkgs; [ git ];
  };
in
{
  boot.loader.grub = {
    extraEntries = ''
      menuentry "Rescue Boot" {
        linux /rescue-kernel init=${netboot.config.system.build.toplevel}/init ${toString netboot.config.boot.kernelParams}
        initrd /rescue-initrd
      }
    '';
  };

  boot.loader.grub.extraFiles = {
    "rescue-kernel" = "${netboot.config.system.build.kernel}/bzImage";
    "rescue-initrd" = "${netboot.config.system.build.netbootRamdisk}/initrd";
  };
}
