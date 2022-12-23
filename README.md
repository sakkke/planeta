planeta
=======

Development
-----------
### Build dependencies
```shell
sudo pacman -S --needed --noconfirm --noprogressbar \
    arch-install-scripts \
    archiso \
    darkhttpd
```

### Optional dependencies
```shell
sudo pacman -S --needed --noconfirm --noprogressbar \
    edk2-ovmf \
    pv \
    qemu-base \
    qemu-ui-sdl
```

They are used in testing or burning.

### Recommended build environment
#### Disable sudo prompt
Add the following to `/etc/sudoers`.
```
username ALL=(ALL:ALL) NOPASSWD /usr/bin/pacman
username ALL=(ALL:ALL) NOPASSWD /usr/bin/pacstrap
```

### Build
```shell
# Download packages
for packages in *packages.*; do
    cat "$packages" \
        | awk '{ if ($0 == "# @exit-pkg-add") { exit } print $0 }' \
        | grep -v '^#' \
        | grep -v '^$'
done \
    | sort -u \
    | sudo ./pkg-add.sh -

# Pre-build packages
(
    cd packages

    for package in *; do
        case "$package" in
            linux-xanmod-rt )
                gpg --receive-keys 38DBBDC86092693E
                ;;
        esac
    done
)

# Build packages
for package in packages/*; do
    (
        cd "$package"
        makepkg -rs --noconfirm
    )
done

# Add builded packages to a repo
for package in packages/*/*.pkg.tar.zst; do
    sudo cp "$package" planeta/
    sudo repo-add -q planeta/planeta.db.tar.gz "$package"
done

# Serve downloaded packages
./pkg-serve.sh &
pid=$!

# Wait while the server starts
while ! curl -s http://localhost:8080/ &> /dev/null; do
    sleep 1
done

# Build filesystem images
sudo ./fsimage.sh

# Build a utility program
gcc -o airootfs/usr/bin/planeta planeta.c

# Build an ISO
sudo mkarchiso -v .

# Kill the process
pkill -P $pid
```

### Clean up artifacts
```shell
sudo ./clean.sh
```

### Rebuild filesystem images
```shell
sudo rm -f \
    airootfs/efi.tar.zst \
    airootfs/root.tar.zst \
    efi.fat \
    root.btrfs
```

### Rebuild an ISO
```shell
sudo rm -rf \
    out \
    work
```

### Test an ISO
```shell
run_archiso -ui out/planeta-*-x86_64.iso
```

### Burn an ISO
```console
$ sudo ./burn.sh [disk]...
```
