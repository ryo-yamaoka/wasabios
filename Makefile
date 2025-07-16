run-uefi:
	cargo build --target x86_64-unknown-uefi
	mkdir -p mnt/EFI/BOOT
	cp target/x86_64-unknown-uefi/debug/wasabi.efi mnt/EFI/BOOT/BOOTX64.EFI
	qemu-system-x86_64 -bios third_party/ovmf/RELEASEX64_OVMF.fd -drive format=raw,file=fat:rw:mnt

run-hexbin:
	xxd -r -p img.hex > img.bin
	qemu-system-x86_64 -drive file=img.bin,format=raw
