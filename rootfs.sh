#!/bin/bash

rootfs_dir=rootfs
mkdir -p "$rootfs_dir"
config=pacman.conf
packages=pacstrap_packages.x86_64
pacstrap -C "$config" "$rootfs_dir" - < "$packages"
rootfs=rootfs.tar.zst

(
    cd "$rootfs_dir"
    tar -acf ../"$rootfs" *
)

rm -rf "$rootfs_dir"
