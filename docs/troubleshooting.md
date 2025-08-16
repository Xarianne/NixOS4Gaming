# Troubleshooting

## Common Issues:
- **Flake errors**: Make sure you've changed the username and hostname in `flake.nix`
- **GPU issues**: This config is AMD-specific. For NVIDIA, you'll need to modify the graphics configuration; as I have not had to do it myself I can't give you proper instructions; in the **That's it folks!** section below there is a video that has that information, but checking the NixOS documentation is your best bet
- **Build failures**: Try `sudo nixos-rebuild switch --flake .#your-hostname --show-trace` for more detailed error messages
- **Mesa-git build failure**: mesa-git is the developer version of the drivers; builds sometimes can fail if you run the update, if that's what's causing the issue, then disable mesa-git temporarily by going to `/etc/nixos/modules/hardware/amd-graphics.nix` and comment out the mesa-git drivers:
  ```Nix
  # Mesa-git drivers - bleeding edge graphics drivers for AMD
  # chaotic.mesa-git.enable = true;  # <----- comment this line to turn off mesa-git
  ```

## Disabling Features You Don't Want:
- **Secure boot**: Remove lanzaboote imports and delete `modules/security`
- **Flatpaks**: Remove the nix-flatpak import from `flake.nix` and the flatpak import from `configuration.nix`
- **Gaming packages**: Comment out Steam and gaming-related packages in `configuration.nix`


## Helpful Tutorials
As I said at the beginning these are just my own configuration files which I modified for other people's use. I tried to leave comments where action would be necessary to turn features on or off. 

I don't pretend to know enough to be able to help with troubleshooting, but hopefully this video by Vimjoyer **Is NixOS The Best Gaming Distro** might help (he also has instructions for Nvidia): https://www.youtube.com/watch?v=qlfm3MEbqYA

His channel is probably one of the best NixOS channels around.

I also suggest watching this video series by tony for general NixOS knowledge:

- **How to Install Customize and NixOS Linux:** https://youtu.be/lUB2rwDUm5A?si=DRc2Wegs8m1-nvk0
- **How to use NixOS Home Manager:** https://youtu.be/bFmvnJVd5yQ?si=hrMM7zITolmTOT9P
- **How to use NixOS Flakes:** https://youtu.be/v5RK3oNRiNY?si=uoFImHG31CWuZMbu 
  

