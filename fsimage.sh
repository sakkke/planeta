#!/bin/bash

shopt -s extglob

root_file=root.btrfs
fallocate -l 16GiB "$root_file"
mkfs.btrfs "$root_file"
root_dir=/
mnt=root
root_mountpoint="$(realpath "$mnt""$root_dir")"
mount --mkdir "$root_file" "$root_mountpoint"
efi_file=efi.fat
fallocate -l 300MiB "$efi_file"
mkfs.fat -F 32 "$efi_file"
efi_dir=/boot
efi_mountpoint="$(realpath "$mnt""$efi_dir")"
mount --mkdir "$efi_file" "$efi_mountpoint"
config=pacman.conf
packages=pacstrap_packages.x86_64

cat "$packages" \
    | awk '{ if ($0 == "# @exit-pkg-add") { exit } print $0 }' \
    | grep -v '^#' \
    | grep -v '^$' \
    | sort -u \
    | pacstrap -C "$config" "$root_mountpoint" -

cp -RT pacstrap_airootfs "$root_mountpoint"
arch-chroot "$root_mountpoint" systemctl enable systemd-networkd.service
arch-chroot "$root_mountpoint" passwd -l root
arch-chroot "$root_mountpoint" systemctl enable docker.service
arch-chroot "$root_mountpoint" systemctl enable lxdm.service
efi_fsimage=airootfs/efi.tar.zst

(
    cd "$efi_mountpoint"
    tar -acf "$OLDPWD"/"$efi_fsimage" *
)

root_fsimage=airootfs/root.tar.zst

(
    cd "$root_mountpoint"
    tar -acf "$OLDPWD"/"$root_fsimage" !("${efi_dir:1}")
)

umount -R "$root_mountpoint"
rm -rf "$root_mountpoint"
