#!/bin/bash

set -e

for disk in "$@"; do
    pv out/planeta-*-x86_64.iso >> "$disk"
done
