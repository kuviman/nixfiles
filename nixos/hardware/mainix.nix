# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, modulesPath, ... }:

{
  imports =
    [
      (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  specialisation.new-partitions.configuration.fileSystems = {
    "/boot" = lib.mkForce {
      device = "/dev/disk/by-partuuid/1a0d4287-f823-4321-81d5-23cd8c6137cb";
      fsType = "vfat";
    };
    "/" = lib.mkForce {
      device = "/dev/disk/by-partuuid/d65875ac-441d-41a2-81ac-bac57474acd7";
      fsType = "ext4";
    };
  };

  fileSystems."/" =
    {
      device = "/dev/disk/by-partuuid/be5a7a65-d27b-9c4b-a425-3c6b3d1cfda1";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    {
      device = "/dev/disk/by-partuuid/3cbc857d-6fc4-3e4b-84fb-9d7a94342cbe";
      fsType = "vfat";
    };

  swapDevices = [ ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp5s0.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp4s0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
