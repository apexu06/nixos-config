{pkgs, ...}: {
  users.users.apexu.extraGroups = ["libvirtd"];
  environment.systemPackages = with pkgs; [
    virt-viewer
    spice
    spice-gtk
    spice-protocol
    virtio-win
    win-spice
  ];

  programs.virt-manager.enable = true;

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
