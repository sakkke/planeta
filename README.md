planeta
=======

Development
-----------
### Build dependencies
```shell
sudo pacman -S --needed --noconfirm \
    arch-install-scripts \
    archiso \
    darkhttpd
```

### Build
```shell
# Download packages
sort -u *packages.* | sudo ./pkg-add.sh -

# Serve downloaded packages
./pkg-serve.sh &

# Build a rootfs
sudo ./rootfs.sh

# Build an ISO
sudo mkarchiso -v .
```

### Clean up artifacts
```shell
sudo ./clean.sh
```
