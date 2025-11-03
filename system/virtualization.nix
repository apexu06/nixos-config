{pkgs, ...}: {
  users.users.apexu.extraGroups = ["libvirtd"];
  environment.systemPackages = with pkgs; [
    virt-manager
    virt-viewer
    spice
    spice-gtk
    spice-protocol
    virtio-win
    win-spice
  ];

  virtualisation = {
    libvirtd = {
      enable = true;
      qemu = {
        package = pkgs.qemu_kvm;
        runAsRoot = true;
        swtpm.enable = true;
      };
    };

    docker = {
      enable = true;
    };

    spiceUSBRedirection.enable = true;
    vmware.guest.enable = true;
  };

  services.spice-vdagentd.enable = true;
}
