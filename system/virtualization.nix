{pkgs, ...}: {
  users.users.apexu.extraGroups = ["libvirtd"];
  environment.systemPackages = with pkgs; [
    virt-viewer
    spice
    spice-gtk
    spice-protocol
    virtio-win
    win-spice
    docker-compose
    podman-tui
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

    podman = {
      enable = true;
      dockerCompat = true;
      defaultNetwork.settings.dns_enabled = true;
    };

    spiceUSBRedirection.enable = true;
    vmware.guest.enable = true;
  };

  services.spice-vdagentd.enable = true;
}
