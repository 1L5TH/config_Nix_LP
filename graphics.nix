{ config, pkgs, lib, ... }:
{
  hardware.graphics= {
    enable = true;
    #driSupport = true;
    extraPackages = with pkgs; [
      vpl-gpu-rt          # for newer GPUs on NixOS >24.05 or unstable
      intel-compute-runtime
      intel-media-driver
      # onevpl-intel-gpu  # for newer GPUs on NixOS <= 24.05
      # intel-media-sdk   # for older GPUs
    ];
  };
  
  boot.kernelModules = [ "nvidia_uvm" ];
 
  # Load nvidia driver for Xorg and Wayland
  services.xserver.videoDrivers = ["nvidia"];

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = true;
    powerManagement.finegrained = true;
    open = true;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.beta;
  };

  hardware.graphics.enable32Bit = true;

  hardware.nvidia.prime = {
    offload = {
      enable = true;
      enableOffloadCmd = true;
    };
    # Make sure to use the correct Bus ID values for your system!
    intelBusId = "PCI:0:2:0";
    nvidiaBusId = "PCI:01:0:0";
  };

}

