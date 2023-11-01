# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ system, inputs, lib, config, hostname, ... }:

{
  imports =
    [
      inputs.nur.nixosModules.nur
      inputs.sops.nixosModules.sops
      inputs.home-manager.nixosModules.home-manager
      ./hardware/${hostname}.nix
      ./hyperv.nix
      ./obs.nix
      ./android.nix
      ./ios.nix
      ./zsh.nix
      ./nvim/configuration.nix
      ./amdgpu.nix
      ./audio.nix
      ./packages.nix
      ./docker.nix
      ./gitlab/configuration.nix
      ./gnome.nix
      ./hyprland.nix
      ./wayfire.nix
      ./xdg-desktop-portal.nix
      ./minecraft.nix
    ];

  nix = {
    # This will add each flake input as a registry
    # To make nix3 commands consistent with your flake
    registry = lib.mapAttrs (_: value: { flake = value; }) inputs;

    # This will additionally add your inputs to the system's legacy channels
    # Making legacy nix commands consistent as well, awesome!
    nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}") config.nix.registry;

    settings = {
      # Enable flakes and new 'nix' command
      experimental-features = [ "nix-command" "flakes" ];
      # Deduplicate and optimize nix store
      auto-optimise-store = true;
    };

    # For nix-direnv
    extraOptions = ''
      keep-outputs = true
      keep-derivations = true
    '';
  };
  nixpkgs = {
    # You can add overlays here
    overlays = [
      # If you want to use overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })

      # Waybar experimental features
      (self: super: {
        waybar = super.waybar.overrideAttrs (oldAttrs: {
          mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
        });
      })
    ];
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
      permittedInsecurePackages = [
        "python-2.7.18.6" # for aseprite
      ];
    };
  };

  networking.hostName = hostname;

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot";

  time.hardwareClockInLocalTime = true; # For dual booting Windows

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Saratov";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  services.flatpak.enable = true;

  services.xserver.displayManager.gdm.enable = true;

  # Configure keymap in X11
  services.xserver = {
    layout = "us,ru";
    xkbVariant = "";
  };

  # Swaylock pam
  security.pam.services.swaylock = {
    text = ''
      auth include login
    '';
  };

  # Disable mouse acceleration
  services.xserver.libinput.mouse.accelProfile = "flat";

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.kuviman = {
    isNormalUser = true;
    extraGroups = [ "networkmanager" "wheel" ];
  };
  home-manager.users.kuviman.imports = [ ../home/kuviman.nix ../home/home.nix ];

  users.users.mikky_ti = {
    isNormalUser = true;
  };

  # for l2tp vpn - https://github.com/NixOS/nixpkgs/issues/64965#issuecomment-741920446
  services.strongswan = {
    enable = true;
    secrets = [
      "ipsec.d/ipsec.nm-l2tp.secrets"
    ];
  };

  home-manager.extraSpecialArgs = {
    inherit inputs hostname system;
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.11"; # Did you read the comment?

  hardware.xpadneo.enable = true;
}
