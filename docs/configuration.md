# What's Included

## Gaming Packages
**Steam** of course. I am using the native version here for ease of integration (not the Flatpak). Also **Proton Plus** so you can install your favourite custom Proton versions (for example Proton GE or Cachy Proton), **Lutris**, **MangoHud** (and **MangoJuice** to configure it), **Discord** (to chat with your friends while playing). There is also RetroArch if you need emulation.

### Emulation Support
With RetroArch. It supports most emulation environments.

### OpenRGB and OpenRazer
For your keyboard/PC case lighting needs.

## OBS and DaVinci Resolve
If you are a content creator who likes to share their gaming-related content.

## Other Packages
Just have a look at the Flatpak module and home-manager configuration for the full list.

## Other Features

### Flake-Enabled
So you can use flakes from other users.

### Unstable Channel
For the latest packages, but be aware that there might be regressions as with all rolling releases.

### Home Manager
If you wish to manage software that doesn't need to be installed system-wide in a centralized manner, as well as your dotfiles.

### Ntsync on
Ntsync makes Windows games that use Proton run better on Linux. When Windows games need to coordinate different parts of the program they use special Windows-only features. Ntsync translates these features for Linux, making games run smoother with fewer crashes and glitches. Proton GE 10-10 or newer pick up Ntsync automatically if the ntsync module is on (which is why I turned it on). However bear in mind that just because a Proton version supports Ntsync, it doesn't mean it will perform better than one that doesn't, but which has other optimizations.

### Virtualization and Virtual Machine Manager
If you want to try other distros or you need to access Windows to update those pesky peripherals that cannot be updated on Linux, this will have you covered. When you first start Virtual Machine Manager it might tell you you do not have a connection. Just go to **File > Add Connection**, then you should be ready to install your virtual machine.

### Desktop Icons for Easy Updates
While you can create aliases so you could just do it all in terminal, if you are a GUI type of person I made these two desktop icons so you can update and rebuild your system without having to retype the command every time. Just place them on your desktop and/or in `/home/.local/share/applications` if you want them to also show up in your application menu. Rebuild is for when you make changes to your configuration. Update will update your packages and also rebuild.

## Mesa-Git Drivers and the CachyOS Kernel
These are installed via the Chaotic Nyx repo (enabled in the flake): https://github.com/chaotic-cx/nyx

Please note that when rebuilding the system will create two snapshots: one with the base mesa drivers and one with the bleeding edge mesa-git drivers. So you can always choose what to use. The mesa-git drivers can sometimes cause DaVinci Resolve to complain about your graphics card. You have two choices: you can load the snapshot with the base mesa when you want to use DaVinci Resolve and then swap back to mesa-git when you are done, or you can decide to turn off mesa-git entirely. The installer will ask you if you want to install mesa-git in the first place. If you are not using the installer, you can go to the modules/hardware/amd-graphics.nix and uncomment the mesa-git line to turn it on:

```nix
  # Mesa-git drivers - bleeding edge graphics drivers for AMD
  # Provides performance improvements for newer AMD GPUs (especially RDNA 4)
  # chaotic.mesa-git.enable = true;   # <----- uncomment this line if you want mesa-git
```  

If you don't want to use the CachyOS Kernel the modules/gaming/gaming-optimizations.nix file still has NixOS's own kernel. Uncomment the kernel you want to use:

```nix
  # Use latest standard NixOS kernel, choose either this or the CachyOS one (below)
  # boot.kernelPackages = pkgs.linuxPackages_latest;

  # Use Cachy kernel (turned on by default)
  boot.kernelPackages = pkgs.linuxPackages_cachyos;
```
