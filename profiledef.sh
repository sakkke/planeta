#!/usr/bin/env bash
# shellcheck disable=SC2034

iso_name="planeta"
iso_label="PLANETA_$(date +%Y%m)"
iso_publisher="sakkke <https://github.com/sakkke>"
iso_application="planeta"
iso_version="$(date +%Y.%m.%d)"
install_dir="plaeta"
buildmodes=('iso')
bootmodes=('bios.syslinux.mbr' 'bios.syslinux.eltorito'
           'uefi-ia32.grub.esp' 'uefi-x64.grub.esp'
           'uefi-ia32.grub.eltorito' 'uefi-x64.grub.eltorito')
arch="x86_64"
pacman_conf="pacman.conf"
airootfs_image_type="squashfs"
airootfs_image_tool_options=('-comp' 'xz' '-Xbcj' 'x86' '-b' '1M' '-Xdict-size' '1M')
file_permissions=(
  ["/etc/gshadow"]="0:0:400"
  ["/usr/bin/planeta"]="0:0:4755"
  ["/etc/shadow"]="0:0:400"
  ["/usr/bin/setup-planeta"]="0:0:755"
)
