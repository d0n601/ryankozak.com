+++
title = 'Installing Arch Linux on the Pinebook Pro with LUKS Encrypted Root...Again'
date = 2021-06-28T15:23:06-07:00
hideToc = true
description = "Updated guide for installing Arch Linux on Pinebook Pro with LUKS encryption using Sven Kiljan's archlinuxarm-pbp project."
+++
In my [previous post](/luks-encrypted-arch-linux-on-pinebook-pro/) I went through the steps I used to install Arch Linux on my Pinebook Pro with a LUKS encrypted root partition. It appears that the repositories used in that post have been retired, and the packages hosted at *https://nhp.sh/pinebookpro/* are no longer there. A big thanks to [Nadia Holmquist Pedersen](https://github.com/nadiaholmquist) for all the work she's done for Arch on the Pinebook Pro.

The following instructions use [Sven Kiljan's](https://kiljan.org/) project. You can find his blog post discussing it [here](https://kiljan.org/2021/06/20/arch-linux-arm-on-a-pinebook-pro/), and the GitHub repository [here](https://github.com/SvenKiljan/archlinuxarm-pbp/).


## Installation on microSD card
These steps are largely for my personal reference, but they're here for the public to read in the event that they may help someone do something similar. The majority of them are copied straight from [archlinuxarm-pbp's INSTALL.md](https://github.com/SvenKiljan/archlinuxarm-pbp/blob/main/INSTALL.md), with LUKS encryption stuff inserted here and there.

0. Boot from the ArchISO. In my previous post I flashed my eMMC with Naudia's ArchISO. This is what I used to complete the steps below to reinstall Arch on my SD Card.

0. `wifi-menu` to get connected.

1. Zero the beginning of the SD card: `dd if=/dev/zero of=/dev/mmcblk1 bs=1M count=32`

2. Start fdisk to partition the SD card or eMMC module: `fdisk /dev/mmcblk1`

3. At the fdisk prompt, create the new partition:
    1. Type **o**. This will clear out any partitions on the drive.
    2. Type **p** to list partitions. There should be no partitions left.
    3. Type **n**, then **p** for primary, **1** for the first partition on the drive, **32768** for the first sector, and then type **442367** for the last sector.
    4. Type **t**, then **c** to set the first partition to type W95 FAT32 (LBA).
    5. Type **n**, then **p** for primary, **2** for the second partition on the drive, **442368** for the first sector, and then press ENTER to accept the default last sector.
    6. Write the partition table and exit by typing **w**.

4. Create and mount the FAT filesystem: `mkfs.vfat -n BOOT_ALARM /dev/mmcblk1p1`

5. Encrypt the second partition with: `cryptsetup -y -v luksFormat /dev/mmcblk1p2`

6. Open the encrypted partition: `cryptsetup open /dev/mmcblk1p2 cryptroot`

7. Write the EXT4 file system to the partition we've just opened (our encrypted root) `sudo mkfs.ext4 -L ROOT_ALARM /dev/mapper/cryptoroot`

8. MOUNT UP!: `sudo mount /dev/mapper/crytoroot /mnt && sudo mount /dev/mmcblk1p1 /mnt/boot`

9. Download  the filesystem via `cd /mnt && wget https://github.com/SvenKiljan/archlinuxarm-pbp/releases/latest/download/ArchLinuxARM-pbp-latest.tar.gz `

10. Extract the root filesystem: `sdtar -xpf ArchLinuxARM-pbp-latest.tar.gz -C .`

12. Install the Tow-Boot bootloader:
  ```
  dd if=boot/idbloader.img of=/dev/mmcblk1p1 seek=64 conv=notrunc,fsync
  dd if=boot/tow-boot.itb of=/dev/mmcblk1p1 seek=16384 conv=notrunc,fsync
  ```

13. Enter chroot via `arch-chroot /mnt`

14. Edit `/etc/locale.gen`, uncommenting what you need. For me this was `en_US.UTF-8 UTF-8`.

15. Execute `locale-gen` to generate the locales.

16. Modify `/etc/mkinitcpio.conf` to include hooks, `HOOKS=(base udev autodetect keyboard keymap modconf block encrypt filesystems fsck)`

17. Issue `blkid` to get the UUID of `/dev/mapper/cryptroot` and modify `/boot/extlinux/extlinux.conf` to look like such (replacing YOUR-UUID with your own):
  ```
  LABEL Arch Linux ARM
  KERNEL /Image
  FDT /dtbs/rockchip/rk3399-pinebook-pro.dtb
  APPEND initrd=/initramfs-linux.img console=ttyS2,1500000 console=tty0 rootwait cryptdevice=UUID=YOUR-UUID:cryptroot root=/dev/mapper/cryptroot rw plymouth.ignore-serial-consoles
  ```

18. Regenerate all the initramfs images with `mkinitcpio -P`

19. Now, leave chroot and reboot your machine to the new install on the SD card.

20. Log in as root (password is "root") and connect to the wifi with `wifi-menu` again.

22. Synchronize the system and RTC clocks:
  ```
  timedatectl set-ntp on
  hwclock -w
  ```

23. Initialize the pacman keyring and populate the Arch Linux ARM and Pinebook Pro [package signing](https://archlinuxarm.org/about/package-signing) keys:
  ```
  pacman-key --init
  pacman-key --populate archlinuxarm
  pacman-key --populate archlinuxarm-pbp
  ```

24. Reboot, change password for *root* user, remove *alarm* user and add your own...continue to setup things how you'd like them to be (window manager, all other software, the fun stuff).




### References
1. [https://github.com/SvenKiljan/archlinuxarm-pbp/blob/main/INSTALL.md](https://github.com/SvenKiljan/archlinuxarm-pbp/blob/main/INSTALL.md)
2. [https://wiki.archlinux.org/index.php/installation_guide](https://wiki.archlinux.org/index.php/installation_guide)
3. [https://forum.pine64.org/showthread.php?tid=14238](https://forum.pine64.org/showthread.php?tid=14238)
4. [https://ryankozak.com/luks-encrypted-arch-linux-on-pinebook-pro/](https://ryankozak.com/luks-encrypted-arch-linux-on-pinebook-pro/)
5. [https://rudism.com/pinebook-pro-arch-linux-alternative/](https://rudism.com/pinebook-pro-arch-linux-alternative/)
