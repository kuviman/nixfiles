{ ... }:
{
  # Conflicts with libvirt https://github.com/NixOS/nixpkgs/issues/227070
  services.dnsmasq = {
    # enable = true;
  };
}
