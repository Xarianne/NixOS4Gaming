# /etc/nixos/modules/hardware/amd-graphics.nix
{ config, pkgs, lib, ... }:
{
  # Mesa-git drivers - bleeding edge graphics drivers for AMD
  # chaotic.mesa-git.enable = true;  # <----- uncomment this line if you want mesa-git
  
  # Graphics configuration for AMD
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      # Add ROCm compute libraries for DaVinci Resolve
      rocmPackages.clr.icd
      
      # Mesa demos for testing OpenGL
      mesa-demos
      
      # Complete GStreamer codec suite (matching Bazzite/Universal Blue)
      gst_all_1.gstreamer
      gst_all_1.gst-plugins-base
      gst_all_1.gst-plugins-good
      gst_all_1.gst-plugins-bad
      gst_all_1.gst-plugins-ugly
      gst_all_1.gst-libav  # FFmpeg integration for GStreamer
      gst_all_1.gst-vaapi  # VA-API hardware acceleration
      
      # Additional multimedia libraries
      ffmpeg-full      # Complete FFmpeg with all codecs
      libva            # Video Acceleration API
      libva-utils      # VA-API utilities (vainfo, etc.)
      vaapiVdpau       # VAAPI driver that uses VDPAU
      libvdpau-va-gl   # VDPAU driver that uses VA-GL
      
      # Note: Mesa drivers are included automatically with hardware.graphics.enable
    ];
    
    extraPackages32 = with pkgs.pkgsi686Linux; [
      # 32-bit codec support for compatibility
      gst_all_1.gstreamer
      gst_all_1.gst-plugins-base
      gst_all_1.gst-plugins-good
      gst_all_1.gst-plugins-bad
      gst_all_1.gst-plugins-ugly
      gst_all_1.gst-libav
      libva
      # Note: Mesa drivers included automatically
    ];
  };
}
