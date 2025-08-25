build:
	cargo build --target x86_64-unknown-uefi

run-uefi: build
	mkdir -p mnt/EFI/BOOT
	cp target/x86_64-unknown-uefi/debug/wasabi.efi mnt/EFI/BOOT/BOOTX64.EFI
	qemu-system-x86_64 -m 4G -bios third_party/ovmf/RELEASEX64_OVMF.fd -drive format=raw,file=fat:rw:mnt -device isa-debug-exit,iobase=0xf4,iosize=0x01

run-hexbin:
	xxd -r -p img.hex > img.bin
	qemu-system-x86_64 -drive file=img.bin,format=raw
