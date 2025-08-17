# NixOS for Gaming (for AMD)

These are my personal configuration files. I decided to share them in case other people want a jump-start for their own gaming machine. As I am new to NixOS, this might not be the most efficient code you have ever seen, but the setup works. Feel free to tweak it for your own use. I use KDE so bear this in mind.

## Quick Start

First install NixOS via the graphical installer. You will need to disable Secure Boot, but I included Lanzaboote if you want to turn it back on after installation. For more information please see [Lanzaboote Secure Boot Setup](docs/installation.md#lanzaboote-secure-boot-setup).

If you're the trusting type I've created an installation script that will install the files for you:

```bash
curl -sSL https://raw.githubusercontent.com/Xarianne/NixOS4Gaming/main/nixos4gaming-installer-amd.sh -o installer.sh
chmod +x installer.sh 
./installer.sh
```

The script will ask you which kernel to use (CachyOS or the latest NixOS Kernel), whether you want mesa-git, emulation support, DaVinci Resolve and whether you want virtualisation to be turned on. Not everyone needs DaVinci and if your PC does not support virtualisation then it will be pointless to install it.

If you are not the trusting type, then follow the [manual installation instructions](docs/installation.md).

## What You're Getting

**Gaming stuff**: Steam (native, not Flatpak), Proton Plus for custom Proton versions, Lutris, MangoHud, Discord, RetroArch.

**The controversial bits**: Mesa-git drivers and CachyOS kernel via Chaotic Nyx repo. These may or may not improve your performance - I've written up my thoughts on this in [A Note on "Gaming Optimization"](docs/gaming-optimisations.md).

**Other bits**: Declarative Flatpak setup (blame the Universal Blue team for me liking Flatpak), secure boot support with Lanzaboote, virtualisation for when you need to update those pesky peripherals in Windows.

## Full Documentation

Since this README was getting rather long, I've split things up:

- [Installation Guide](docs/installation.md) - Both automatic and manual installation
- [What's Actually Included](docs/configuration.md) - Full package lists and configuration details  
- [Gaming Optimisations Explained](docs/gaming-optimisations.md) - My take on whether these "optimisations" actually work
- [When Things Go Wrong](docs/troubleshooting.md) - Common issues and fixes

## That's It Folks!

As I said, these are just my own configuration files which I modified for other people's use. I don't pretend to know enough to be able to help with troubleshooting, but hopefully the guides help.

If you want a fully fledged gaming distro instead, check out [GLF OS](https://www.gaminglinux.fr/glf-os/en/), [Bazzite](https://bazzite.gg) or the other [alternatives](docs/alternatives.md) I've listed.
