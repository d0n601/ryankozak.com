---
title: "Installing Arch Linux on the Pinebook Pro with LUKS Encrypted Root"
author: Ryan Kozak
layout: post
description: Installing Arch Linux on Pinebook Pro with LUKS encrypted root partition
permalink: /luks-encrypted-arch-linux-on-pinebook-pro/
categories:
  - Linux
  - Pinebook Pro
tags:
  - linux
  - Arch Linux
  - Pinebook Pro
---

![Pinebook Pro Running Arch](/wp-content/uploads/2020/12/pinebook_arch.png)

My Pinebook Pro came in last week and yesterday I finally got a chance to really play with it. The first thing I wanted to do was get Arch installed on it with an encrypted root partition. I need these notes as a reference to use the next time I do this, so I figured I'd post them up to help anyone else out that may be trying to achieve the same thing. This post ignores post installation configuration. It just gets you booting into the terminal of your LUKS encrypted partition. From there it's up to you to setup users, install your desktop manager, etc.

### Preperation
This may not be anyone else's preference, but I chose to flash the eMMC with the archiso, and install Arch onto the SD card. I don't have much use for the internal eMMC to be honest. I was more excited that the Pinebook can run an OS off the microSD. For now I figure I'll just keep the archiso on the eMMC to use for recovery when I need it. I'm going to skip the steps required to flash the ISO to the eMMC and the SD card. If you're to the point of installing and using Arch you won't need these steps, and you'll likely not want to do exactly what I did anyway.

**Note**: At the time of posting this Pre-built image 2020-07-02 just wouldn't boot for me, so I used [Pre-built image 2020-06-16](https://github.com/nadiaholmquist/archiso-pbp/releases/tag/20200616).


### Installation
Remember `/dev/mmcblk1` is the SD card, and `/dev/mmcblk2` is eMMC, so adjust the steps accordingly to install this where you're intending to.
0. Boot from ArchISO.
1. `wifi-menu` and select wireless network.
2. Set your clock so pacman doesn't get ssl errors, `timedatectl set-ntp true`
3. Partition boot on SD card `fdisk /dev/mmcblk1`
  * `n`
  * `p`
  * `1`
  * First sector `65536`
  * +128M
  * Check partitions with `p` and note last sector of first partition.
  * `n`
  * `p`
  * `2`
  * First sector is right after the last sector of the first.
  * Size for the rest of the drive.
  * `w` write the changes
4. Write an EXT4 file system to the boot partition `mkfs.ext4 /dev/mmcblk1p1`.
5. Encrypt the second partition with LUKS `cryptsetup -y -v luksFormat /dev/mmcblk1p2`.
6. Open the encrypted partition `cryptsetup open /dev/mmcblk1p2 cryptroot`.
7. Write the EXT4 file system to the partition we've just opened (our encrypted root) `mkfs.ext4 /dev/mapper/cryptroot`.
8. Mount the new partition
  1. First make the *mnt* directory with `mkdir /mnt`.
  2. Now mount the encrypted root partition there, `mount /dev/mapper/cryptroot /mnt`.
9. Create a `/mnt/boot` directory and mount the first partition (boot partition) to the new boot directory.
  1. `mkdir /mnt/boot`
  2. `mount /dev/mmcblk1p1 /mnt/boot`
7. Install everything with pacstrap via `pacstrap /mnt base base-devel linux-pbp pbp-keyboard-hwdb ap6256-firmware vim` add whatever else you know you want here.
8. Use `genfstab -U /mnt` to create a new fstab at `/mnt/etc/fstab`.
9. `arch-chroot /mnt` to get into your installation.
10. Edit `/etc/locale.gen`, uncommenting what you need. For me this was `en_US.UTF-8 UTF-8`.
11. Execute `locale-gen` to generate the locales.
12. Create `/etc/locale.conf` and add `LANG=en_US.UTF-8` (or whatever other languages you need).
13. Modify `/etc/mkinitcpio.conf` to include modules, `MODULES=(panfrost rockchipdrm drm_kms_helper hantro_vpu analogix_dp rockchip_rga panel_simple arc_uart cw2015_battery i2c-hid iscsi_boot_sysfs jsm pwm_bl uhid)`
14. Modify `/etc/mkinitcpio.conf` to include hooks, `HOOKS=(base udev autodetect keyboard keymap modconf block encrypt filesystems fsck)`
15. Make the `extlinux` directory `mkdir /boot/extlinux` and create the file below `vim /boot/extlinux/extlinux.conf` (use blkid to find your UUID).
Tip for UUID, I did a `blk >> /boot/extlinux/extlinux.conf` to write the UUID's into the file so I could actually see them as I was in VIM, then just deleted the lines before saving.
```
LABEL Arch Linux ARM
KERNEL /Image
FDT /dtbs/rockchip/rk3399-pinebook-pro.dtb
APPEND initrd=/initramfs-linux.img console=tty1 rootwait cryptdevice=UUID=YOUR-UUID:cryptroot root=/dev/mapper/cryptroot rw
```
16. Enable the network manager `systemctl enable NetworkManager`.
17. Set root password with `passwd`.
18. Reboot, and continue to setup things how you'd like.



### References
1. [https://wiki.archlinux.org/index.php/installation_guide](https://wiki.archlinux.org/index.php/installation_guide)
2. [https://github.com/nadiaholmquist/archiso-pbp](https://github.com/nadiaholmquist/archiso-pbp)
3. [ https://rudism.com/installing-arch-linux-on-the-pinebook-pro/](https://rudism.com/installing-arch-linux-on-the-pinebook-pro)
4. [https://www.bencode.net/posts/pinebook/](https://www.bencode.net/posts/pinebook/)
