# A Note on "Gaming Optimization"

Things like custom kernels, mesa-git drivers, network optimizations, etc. may or may not result in improved gaming performance. For example, for me mesa-git lifted my graphics card performance by about 20% and decreased temperatures, compared to the version that was available on stable Fedora. But Fedora does take its time to test software before it releases it. When I benchmarked again against what is available just from the unstable branch in NixOS (25.2) the performance difference was within margin of error. However, when I benchmarked 25.2 on Bazzite (they use the Terra drivers), my PC was running slightly hotter. So whether you will get a "performance gain" depends on what you are comparing your mesa-git drivers to, and whether your hardware benefits from the new features. If you are on the latest generation graphics card, I would suggest you get the latest drivers to take advantage of new features and improve performance.

For example, I first looked into mesa-git when I needed FSR4 support on my RDNA 4 graphics card. At the time it wasn't available on stable drivers.

On top of this, NixOS unstable already offers very recent drivers, and you might not need to risk the instability of mesa-git. Also bear in mind that this configuration takes two snapshots every time you rebuild: one with the normal drivers and one with mesa-git so you should never be in the position of not being able to use your PC even if you do keep mesa-git.

As to kernel optimizations, schedulers and things like gamemode, on my Ryzen 7600x CPU they make a whole of 0 difference since kernel 6.15 was released. Before then Gamemode made a bit of a difference on Fedora, afterwards it just made things worse, regardless of the distro I used. I included the CachyOS Kernel because people like it and on older hardware it might be helpful. But you have the choice to just use NixOS's own kernel. As you are on the unstable branch, you will get the latest available kernel. 

Network optimizations, gaming VPNs, etc., have never been effective for me. I guess I have a good connection, with low latency and packet loss.

Regarding hardware support, a lot of distros add "extra controller support" such as Xone and the like. The stock Linux kernel has been supporting many controllers for a while now. There might be some really niche ones but as this is closely mirroring my own set up, I am not going to add a load of software that mostly just duplicates what's already supported by the kernel.

Gaming distros are fantastic because they do add wider hardware support (which I don't provide), and a complete out-of-the-box experience. I do provide an installer script that makes things easier, but I generally do not provide software that might apply to a very small minority of people, as this is, first and foremost, just my gaming config I am sharing for people who want a transparent set up they can inspect to kickstart their own configuration. 

I also did some research and testing so this config is the result of that work, but I encourage you to run your own benchmarks, because your hardware mught be different. 

For example, do you WANT to use the CachyOS kernel? It's really easy to switch with this set up, just benchmark your hardware with and without. 

I find that certain Proton versions give me better performance than others. So I included Proton Plus to give you the chance to test the various versions and see what works for you. That's what I do.
