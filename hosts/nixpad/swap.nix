{ ... }:
{
  # Disk-backed swap also provides space for a hibernation image.
  swapDevices = [
    {
      device = "/var/lib/nixpad-hibernate.swap";
      size = 16 * 1024; # MiB
    }
  ];
}
