# rescue_boot.nix
{ config, lib, pkgs, ... }:

{
  boot.loader.grub = {
    extraEntries = ''
      menuentry "NixOS Rescue" {
        search --set=drive1 --fs-uuid ${config.fileSystems."/boot".device}
        search --set=drive2 --fs-uuid ${config.fileSystems."/".device}
        linux ($drive1)/nixos/kernel init=${config.system.build.toplevel}/init systemd.unit=rescue.target
        initrd ($drive1)/nixos/initrd
      }
    '';
    extraEntriesBeforeNixOS = true;
  };
}
