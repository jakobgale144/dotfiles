{
  # lib,
  # modulesPath,
  myvars,
  ...
}:

{
  # imports = [ 
  #   (modulesPath + "/installer/scan/not-detected.nix")
  # ];

  boot.initrd.luks.devices."crypt".device = "/dev/disk/by-uuid/${myvars.test-laptop.primary_uuid}";

  # Our boot device
  fileSystems."/boot".device = "/dev/disk/by-uuid/${myvars.test-laptop.boot_uuid}";
}
