#!/bin/bash

cache_dir=planeta
mkdir -p "$cache_dir"
db_dir="$cache_dir"/db
mkdir -p "$db_dir"
pacman -Syw --cachedir "$cache_dir" --dbpath "$db_dir" --noconfirm "$@"
db="$cache_dir"/planeta.db.tar.gz
repo-add -q "$db" "$cache_dir"/*[!.db][!.files].tar.*[!.sig]
