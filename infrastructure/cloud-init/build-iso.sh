#!/bin/bash

inst_id=$(date '+%y%m%d-%H%M%S')
cat meta-data.tmpl | env DATE=${inst_id} envsubst > meta-data

docker run --rm -it --name cloud-init-seeder -v "$(pwd):/src" --workdir /src debian:bookworm bash -c 'apt update && apt install -y dosfstools mtools && \
  truncate --size 2M seed.iso && \
  mkfs.vfat -n cidata seed.iso && \
  mcopy -oi seed.iso user-data meta-data ::'
