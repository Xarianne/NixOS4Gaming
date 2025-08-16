## Automatic Installation
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

The script will then automate the steps below in the manual installation but it will leave Lanzaboote inactive. If you want to activate secure boot, please follow the instructions in the section below. Do it after you have completed the installation and you have switched to your new build.

Please note that installing everything in this configuration will make your first build rather long. The CachyOS kernel especially will have to be compiled. It will be much faster the next time you build switch, unless you compile a whole new kernel again.

Mesa-git can cause problems for DaVinci Resolve. Please check the section **Mesa-Git Drivers and the CachyOS Kernel**. 

After you have installed everything, if you want easy buttons for updates to your system please see the section **Desktop Icons for Easy Updates**.

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
