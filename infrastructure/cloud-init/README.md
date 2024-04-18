# Cloud Init configuration

To make this infrastructure as portable as possible, cloud-init is used to configure VMs immutably.

## With a Cloud VM

If you're running a virtual machine in the cloud, you'll just want to copy the contents of [`user-data`](./user-data) into their user-data/cloud config field when launching the instance.

## With VM you manage

If you're running the VM yourself, via QEMU/KVM/Lima/VirtualBox or other similar options, you'll need to generate a `CIDATA` iso file, and attach it to your VM at startup.

To do this, you can run the [`build-iso.sh`](./build-iso.sh) script.
