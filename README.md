# NixOS for Gaming (for AMD)

These are my personal configuration files. I decided to share them in case other people want a jump-start for their own gaming machine. As I am new to NixOS, this might not be the most efficient code you have ever seen, but the setup works. Feel free to tweak it for your own use. I use KDE so bear this in mind. 

# Table of Contents

- [Automatic Installation](#automatic-installation)
  - [Lanzaboote Secure Boot Setup](#lanzaboote-secure-boot-setup)
  - [Automount Template](#automount-template)
- [Manual Installation](#manual-installation)
  - [Quick Start](#quick-start)
  - [Initial Setup Instructions](#initial-setup-instructions)
- [What's Included](#whats-included)
- [Other Features](#other-features)
- [Troubleshooting](#troubleshooting)
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
This will download the script, then make it executable and run it. It will also backup your current configuration. Once you have installed everything, you want to type `reboot` in your terminal, if rebooting from the KDE button doesn't work. I have not been able to figure out why this happens yet, regardless of whether I add the configuration manually or via the installer. You will only need to reboot from terminal the first time, then it will work as intended from KDE.

The script will then automate the steps below in the manual installation but it will leave Lanzaboote inactive. If you want to activate secure boot, please follow the instructions in the section below. Do it after you completed the installation and you switched to your new build.

Please note that installing everything in this configuration will make your first build rather long. The CachyOS kernel especially will have to be compiled. It will be much faster the next time you build switch, unless you compile a whole new kernel again.

Mesa-git can cause problems for DaVinci Resolve. Please check the section **Mesa-Git Drivers and the CachyOS Kernel**. 

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
**Steam** of course. I am using the native version here for ease of integration (not the Flatpak). Also **Proton Plus** so you can install your favourite custom Proton versions (for example Proton GE or Cachy Proton), **Lutris**, **MangoHud** (and **MangoJuice** to configure it), **Discord** (to chat to your friends while playing). There is also RetroArch if you need emulation.

### Mesa-Git Drivers and the CachyOS Kernel
These are installed via the Chaotic Nyx repo (enabled in the flake): https://github.com/chaotic-cx/nyx

Please note that when rebuilding the sytem will create two snapshots: one with the base mesa drivers and one with the bleeding edge mesa-git drivers. So you can always choose what to use. The mesa-git drivers can sometimes cause DaVinci Resolve to complain about your graphics card. You have two choices: you can load the snapshot with the base mesa when you want to use DaVinci Resolve and then swap back to mesa-git when you are done, or you can decide to turn off mesa-git entirely. The installer will ask you if you want to install mesa-git in the first place. If you are not using the installer, you can go to the modules/hardware/amd-graphics.nix and uncomment the mesa-git line to turn it on:

```nix
  # Mesa-git drivers - bleeding edge graphics drivers for AMD
  # Provides performance improvements for newer AMD GPUs (especially RDNA 4)
  # chaotic.mesa-git.enable = true;   # <----- uncomment this line if you want mesa-git
```  

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

## A Note on "Gaming Optimisation"
Things like custom kernels, mesa-git drivers, network optimizations, etc. may or may not result in improved gaming performance. For example, for me mesa-git lifted my graphics card performance by about 20% and decreased temperatures, compared to the version that was available on stable Fedora. But Fedora does take its time to test software before it releases it. When I benchmarked again against what is available just from the unstable branch in NixOS (25.2) the performance differnce was within margin of error. However, when I benchmarked 25.2 on Bazzite (they use the Terra drivers), my PC was running slightly hotter. So whether you will get a "performance gain" depends on what you are comparing your mesa-git drivers to, and whether your hardware benefits from the new features. If you are on the latest generation graphics card, I would suggest you get the latest drivers you can get. I first looked into mesa-git when I needed FSR4 support on my RDNA 4 graphics card. At the time it wasn't available on stable drivers, but this has now changed. 

On top of this, NixOS unstable already offers very recent drivers, and you might not need to risk the instability of mesa-git. Also bear in mind that this configuration takes two snapshots every time you rebuild: one with the normal drivers and one with mesa-git so you should never be in the position of not being able to use your PC even if you do keep mesa-git.

As to kernel optimizations, schedulers and things like gamemode, on my Ryzen 7600x CPU they make a whole of 0 difference since kernel 6.15 was released. Before then Gamemode made a bit of a differnce on Fedora, afterwards it just made things worse, regardless of the distro I used. I included the CachyOS Kernel because people like it and on older hardware it might be helpful. But you have the choice to just use NixOS's own kernel. As you are on the unstable branch, you will get the latest available kernel. 

Network optimizations, gaming VPNS, etc., have never been effective for me. I guess I have a good connection, with low latency and packet loss.

Regarding hardware support, a lot of distros add "extra controller support" such as Xone and the like. The stock Linux kernel has been supporting many controllers for a while now. There might be some really niche ones but as this is closely mirroring my own set up, I am not going to add a load of software that mostly just duplicates what's already supported by the kernel.

Gaming distros are fantastic because they do add wider hardware support (which I don't provide), and a complete out-of-the-box experience. I do provide an installer script that makes things easier, but I generally do not provide software that might apply to a very small minority of people as this is, first and foremost, just my gaming config I am sharing for people who want a transparent set up they can inspect to kickstart their own configurtion. I also did some research and testing so this set up is the result of that work, but I encourage you to run your own benchmarks. For example, do you WANT to use the CachyOS kernel? It's really easy to switch with this set up, just benchmark your hardware with and without. 

I find that certain Proton versions give me better performance than others. So I included Proton Plus to give you the chance to test the various version and see what works for you. That's what I do.

## Troubleshooting

### Common Issues:
- **Flake errors**: Make sure you've changed the username and hostname in `flake.nix`
- **GPU issues**: This config is AMD-specific. For NVIDIA, you'll need to modify the graphics configuration; as I have not had to do it myself I can't give you proper instructions; in the **That's it folks!** section below there is a video that has that information, but checking the NixOS documentation is your best bet
- **Build failures**: Try `sudo nixos-rebuild switch --flake .#your-hostname --show-trace` for more detailed error messages
- **Mesa-git build failure**: mesa-git is the developer version of the drivers; builds sometimes can fail if you run the update, if that's what's causing the issue, then disable mesa-git temporarily by going to `/etc/nixos/modules/hardware/amd-graphics.nix` and comment out the mesa-git drivers:
  ```Nix
  # Mesa-git drivers - bleeding edge graphics drivers for AMD
  # chaotic.mesa-git.enable = true;  # <----- comment this line to turn off mesa-git
  ```

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
