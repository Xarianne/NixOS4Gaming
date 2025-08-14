# NixOS for Gaming and Production (for AMD)

These are my personal configuration files. I decided to share them in case other people want a jump-start for their own gaming machine. As I am new to NixOS, this might not be the most efficient code you have ever seen, but the setup works. Feel free to tweak it for your own use. I use KDE so bear this in mind. 

# Table of Contents

- [Automatic Installation](#automatic-installation)
  - [Lanzaboote Secure Boot Setup](#lanzaboote-secure-boot-setup)
  - [Automount Template](#automount-template)
- [Manual Installation](#manual-installation)
  - [Quick Start](#quick-start)
  - [Initial Setup Instructions](#initial-setup-instructions)
    - [IMPORTANT: Again, please change your username and hostname in flake.nix!](#important-again-please-change-your-username-and-hostname-in-flakenix)
    - [Building your system](#building-your-system)
- [What's Included](#whats-included)
  - [Gaming Packages](#gaming-packages)
  - [Mesa-Git Drivers and the CachyOS Kernel](#mesa-git-drivers-and-the-cachyos-kernel)
  - [Declarative Flatpak Setup](#declarative-flatpak-setup)
  - [OBS and DaVinci Resolve](#obs-and-davinci-resolve)
  - [Other Packages](#other-packages)
- [Other Features](#other-features)
  - [Flake-Enabled](#flake-enabled)
  - [Unstable Channel](#unstable-channel)
  - [Home Manager](#home-manager)
  - [Ntsync on](#ntsync-on)
  - [Virtualization and Virtual Machine Manager](#virtualization-and-virtual-machine-manager)
  - [Desktop Icons for Easy Updates](#desktop-icons-for-easy-updates)
- [Troubleshooting](#troubleshooting)
  - [Common Issues](#common-issues)
  - [Disabling Features You Don't Want](#disabling-features-you-dont-want)
- [That's It Folks!](#thats-it-folks)
- [Alternatives](#alternatives)

## Automatic installation
If you are the trusting type I have created an installation script that will install the files for you. It will also ask you which kernel to use (CachyOS or the latest NixOS Kernel), whether you want DaVinci Resolve and whether you want virtualization to be turned on. Not everyone needs DaVinci and if your PC does not support virtualization then it will be pointless to install it. The script is in this repo so you can inspect it. To use it:

1. Turn off Secure Boot if it's on (you will be given the tools to set it up later if you want to keep it, but the NixOS installer doesn't support it by default)
2. Install NixOS using the graphical installer
3. Run my installer script:

```bash
curl -sSL https://raw.githubusercontent.com/Xarianne/NixOS4Gaming/main/nixos4gaming-installer-amd.sh -o installer.sh
chmod +x installer.sh 
./installer.sh
```
This will download the script, then make it executable and run it. Once you have installed everything, you want to type `reboot` in your terminal, if rebooting from the KDE button doesn't work. I have not been able to figure out why this happens yet, regardless of whether I add the configuration manually or via the installer. You will only need to reboot from terminal the first time, then it will work as intended from KDE.

The script will then automate the steps below in the manual installation but it will leave Lanzaboote inactive. If you want to activate secure boot, please follow the instructions in the section below. Do it after you completed the installation and you switched to your new build.

Please note that installing everything in this configuration will make your first build rather long. The CachyOS kernel especially will have to be compiled. It will be much faster the next time you build switch, unless you compile a whole new kernel again.

After you installed everything, if you want easy buttons for updates to your system please see the section **Desktop Icons for Easy Updates**.

### Lanzaboote Secure Boot Setup
I included sbctl, which is required to generate and sign your own keys, and lanzaboote, which is required to enable secure boot. 

**If you don't want secure boot**, then delete the lanzaboote references in `flake.nix` and remove the import `./modules/security/secure-boot.nix` from `configuration.nix`. Then delete the `modules/security` folder.

If you want to enable secure boot, please follow the tutorial in this link: https://github.com/nix-community/lanzaboote. I commented out two lines in the flake.nix file so that Lanzaboote doesn't interfere with your first build as it can cause issues, but you can uncomment them when ready to follow the tutorial to activate it:

```nix
# Secure boot files
          # ./modules/security/secure-boot.nix  <--- Turned off Lanzaboote for the first build as it can cause issues, turn back on after successful build if you want secure boot 
          # lanzaboote.nixosModules.lanzaboote  <--- Turned off Lanzaboote for the first build as it can cause issues, turn back on after successful build if you want secure boot
```

### Automount Template
The default configuration is disk agnostic. If you don't want automount, delete the import in `configuration.nix` as well as the `modules/disks` folder. 

**Current behavior**: Mounts disks when you click on them the first time (without asking for a password).

**For immediate mounting at boot** (useful for Steam game libraries), you need to specify your drives explicitly. Replace the automount.nix file with something like this:

```nix
# /etc/nixos/modules/disks/automount.nix
{ config, pkgs, ... }:
{
  fileSystems."/mnt/games" = {  # Choose your mount point
    device = "/dev/disk/by-uuid/your-uuid-here";  # Find with: lsblk -f
    fsType = "ext4";  # Change to your filesystem (ext4, btrfs, ntfs, etc.)
    options = [ "defaults" "nofail" ];
  };
  
  # Polkit rule to allow users in 'wheel' group to mount internal drives without password
  environment.etc."polkit-1/rules.d/90-local-mount.rules".text = ''
    polkit.addRule(function(action, subject) {
        if (action.id == "org.freedesktop.udisks2.filesystem-mount-system" &&
            subject.isInGroup("wheel")) {
            return polkit.Result.YES;
        }
    });
  '';
}
```

To find your disk UUID: Run `lsblk -f` to see all your drives and their UUIDs.

### Test branch
Should you want to test the latest features, you can pull the install script from the test branch, but be aware that things could break as they are not fully tested yet:

```bash
curl -sSL https://raw.githubusercontent.com/Xarianne/NixOS4Gaming/test/nixos4gaming-installer-amd.sh -o test-installer.sh
chmod +x test-installer.sh 
./test-installer.sh
```

# Manual Installation

## Quick Start

1. Turn off Secure Boot if it's on (you will be given the tools to set it up later if you want to keep it, but the NixOS installer doesn't support it by default)
2. Install NixOS using the graphical installer
3. Clone/download these files to `/etc/nixos/`
4. **IMPORTANT**: Edit `flake.nix` and change `systemUsername` and `systemHostname`
5. Run: `sudo nixos-rebuild switch` (this enables flakes for the first time)
6. From then on use: `nixos-rebuild switch --flake .#your-hostname`
7. I don't provide the hardware-configuration.nix file, as it changes from system to system, keep yours from the original install

**There are a few things to customize before you use these files, so read the full instructions below!**

## Initial Setup Instructions

### IMPORTANT: Again, please change your username and hostname in flake.nix!
The configuration will not work if you don't do this. I marked where you change them in the file itself:
```nix
systemUsername = "your-username"; # Change to your username
systemHostname = "your-hostname"; # Change to your hostname
```

### Building your system
Once you have installed NixOS via the graphical installer and dropped these files in `/etc/nixos/`:

1. **First time only**: `sudo nixos-rebuild switch` (this enables flakes since your system doesn't have them yet)
2. **All subsequent builds**: `nixos-rebuild switch --flake .#your-hostname`

Installing everything in this configuration will make your first build rather long. The CachyOS kernel especially will have to be compiled. It will be much faster the next time you build switch, unless you compile a whole new kernel again.

Note: The default hostname when you install is usually "nixos", but if you changed it during installation, make sure the `#your-hostname` part matches what you set.

To activate secure boot, please see the section **Lanzaboote Secure Boot Setup**.

To change automounting behaviour please see the **Automount template** section.

## What's Included

### Gaming Packages
**Steam** of course. I am using the native version here for ease of integration (not the Flatpak). Also **Proton Plus** so you can install your favourite custom Proton versions (for example Proton GE or Cachy Proton), **Lutris**, **MangoHud** (and **MangoJuice** to configure it), **Discord** (to chat to your friends while playing).

### Mesa-Git Drivers and the CachyOS Kernel
These are installed via the Chaotic Nyx repo (enabled in the flake): https://github.com/chaotic-cx/nyx

Please note that when rebuilding the sytem will create two snapshots: one with the base mesa drivers and one with the bleeding edge mesa-git drivers. So you can always choose what to use.

If you don't want to us the CachyOS Kernel the modules/gaming/gaming-optimizations.nix file still has NixOS's own kernel. Uncomment the kernel you want to use:

```nix
  # Use latest standard NixOS kernel, choose either this or the CachyOS one (below)
  # boot.kernelPackages = pkgs.linuxPackages_latest;

  # Use Cachy kernel (turned on by default)
  boot.kernelPackages = pkgs.linuxPackages_cachyos;
```

### Declarative Flatpak Setup
If you just enable Flatpaks in NixOS you will have to install them as you would in any other distro, which is not a declarative way of doing it. However, thanks to gmodena we can install Flatpaks declaratively: https://github.com/gmodena/nix-flatpak

Why Flatpak? Sandboxing and proprietary software. I like to sandbox my browser and most internet-facing software. I didn't sandbox Steam for ease of integration with things such as MangoHud (your performance overlay). Other software uses Flatpak as their official means of distribution such as OBS. I also provided you with Flatseal so you can easily change Flatpak permissions and Warehouse so you can snapshot and clean up old data. Blame the Universal Blue team for me liking Flatpak ;)

Bear in mind that you can still install nix packages the normal way, the Flatpaks are an addition.

### OBS and DaVinci Resolve
If you are a content creator who likes to share their gaming-related content.

### Other Packages
Just have a look at the Flatpak module and home-manager configuration for the full list.

## Other Features

### Flake-Enabled
So you can use flakes from other users.

### Unstable Channel
For the latest packages, but be aware that there might be regressions as with all rolling releases.

### Home Manager
If you wish to manage software that doesn't need to be installed system-wide in a centralized manner, as well as your dotfiles.

### Ntsync on
Ntsync makes Windows games that use Proton run better on Linux. When Windows games need to coordinate different parts of the program they use special Windows-only features. Ntsync translates these features for Linux, making games run smoother with fewer crashes and glitches. Proton GE 10-10 or newer pick up Ntsync automatically if the ntsync module is on (which is why I turned it on). However bear in mind that just because a Proton version supports Ntsync, it doesn't mean it will peform better than one that doesn't, but which has other optimizations.

### Virtualization and Virtual Machine Manager
If you want to try other distros or you need to access Windows to update those pesky peripherals that cannot be updated on Linux, this will have you covered. When you first start Virtual Machine Manager it might tell you you do not have a connection. Just go to **File > Add Connection**, then you should be ready to install your virtual machine.

### Desktop Icons for Easy Updates
While you can create aliases so you could just do it all in terminal, if you are a GUI type of person I made these two desktop icons so you can update and rebuild your system without having to retype the command every time. Just place them on your desktop and/or in `/home/.local/share/applications` if you want them to also show up in your application menu. Rebuild is for when you make changes to your configuration. Update will update your packages and also rebuild.

## Troubleshooting

### Common Issues:
- **Flake errors**: Make sure you've changed the username and hostname in `flake.nix`
- **GPU issues**: This config is AMD-specific. For NVIDIA, you'll need to modify the graphics configuration; as I have not had to do it myself I can't give you proper instructions; in the **That's it folks!** section below there is a video that has that information, but checking the NixOS documentation is your best bet
- **Build failures**: Try `sudo nixos-rebuild switch --flake .#your-hostname --show-trace` for more detailed error messages

### Disabling Features You Don't Want:
- **Secure boot**: Remove lanzaboote imports and delete `modules/security`
- **Flatpaks**: Remove the nix-flatpak import from `flake.nix` and the flatpak import from `configuration.nix`
- **Gaming packages**: Comment out Steam and gaming-related packages in `configuration.nix`

## That's It Folks!

As I said at the beginning these are just my own configuration files which I modified for other people's use. I tried to leave comments where action would be necessary to turn features on or off. 

I don't pretend to know enough to be able to help with troubleshooting, but hopefully this video by Vimjoyer **Is NixOS The Best Gaming Distro** might help (he also has instructions for Nvidia): https://www.youtube.com/watch?v=qlfm3MEbqYA

His channel is probably one of the best NixOS channels around.

I also suggest watching this video series by tony for general NixOS knowledge:

- **How to Install Customize and NixOS Linux:** https://youtu.be/lUB2rwDUm5A?si=DRc2Wegs8m1-nvk0
- **How to use NixOS Home Manager:** https://youtu.be/bFmvnJVd5yQ?si=hrMM7zITolmTOT9P
- **How to use NixOS Flakes:** https://youtu.be/v5RK3oNRiNY?si=uoFImHG31CWuZMbu

## Alternatives

If you want a fully fledged install-it-and-forget-it operating system image on NixOS I suggest **GLF OS** although it is still in beta: https://www.gaminglinux.fr/glf-os/en/ 

You can also use **Bazzite** if you want a batteries-included distribution with similar rollback and immutability features to NixOS (at least in practice, they are a very different implementation of immutability). You will not be left wanting and it is one of the most solid and encompassing gaming distros out there. Every time I look at their project they added some killer features, for example, you can download the mesa-git drivers to a folder (mesa-git are the latest, bleeding edge drivers that have yet to be tested), and only have Steam games use them, while your system is still on the stable drivers. And you do that with one command line **ujust _mesa-git**. My own NixOS configuration took a lot of inspiration from that project. Here is their website: https://bazzite.gg

If you like Arch (btw) then there is **Garuda** or **CachyOS**.

These are just a few of the gaming distros out there, and they are all ready-to-go and easy to use. They are all an easier starting point than my configuration files.
