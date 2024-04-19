# Virtual Machine Infrastructure

This directory contains the tooling and instructions for getting a VM to run this project up and running using QEMU on a local host.

## Running the VM

Ensure you have QEMU installed (specifically with x86_64 guests enabled, you need the `qemu-system-x86_64` executable in your path).

From _this_ directory, run `bin/run-vm`.

This will do the following:

1.  Download the latest Debian Bookworm generic cloud root disk image, and save it as `./disks/base.qcow2` (skipped if the base image already exists).

1.  Duplicate the base disk image for your VM, and grow its disk from 2Gb to 8Gb (Fun fact: because these images are qcow they only take up the actual space used by the disks, yay sparse file systems!) (skipped if the root disk already exists).

1.  Generate a cloud-init seed iso disk image (see [`../cloud-init`](../cloud-init) for what exactly is going on there) (skipped if the cloud-init iso already exists).

1.  Launch a virtual machine using the root disk and cloud-init iso from the previous steps, configured with several ports forward (details below), and 2Gb of memory (because Kafka likes its memory, this could _probably_ be shrunk, but the Kafka configuration allows it 1Gb of memory usage before it gets OOM killed).

## Port Forwarding

The `bin/run-vm` script forwards the following ports:

-   VM `22` => Host `2222`, to allow SSH (`ssh debian@localhost -p 2222`)
-   VM `4646` => Host `4646`, to allow communicating with Nomad, used to run the services and manage deployments
-   VM `3000` => Host `3000`, to allow access to the rails app!
