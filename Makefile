PATH_TO_EFI ?= "target/x86_64-unknown-uefi/debug/wasabi.efi"

build:
	cargo build --target x86_64-unknown-uefi

run-uefi: build
	mkdir -p mnt/EFI/BOOT
	cp $(PATH_TO_EFI) mnt/EFI/BOOT/BOOTX64.EFI
	set +e; \
	qemu-system-x86_64 -m 4G -bios third_party/ovmf/RELEASEX64_OVMF.fd -drive format=raw,file=fat:rw:mnt -device isa-debug-exit,iobase=0xf4,iosize=0x01; \
	EXIT_CODE=$$?; \
	set -e; \
	if [ $$EXIT_CODE -eq 0 ]; then \
		exit 0; \
	elif [ $$EXIT_CODE -eq 3 ]; then \
		printf "\nPASS\n"; \
		exit 0; \
	else \
		printf "\nFAIL: QEMU returned $$EXIT_CODE\n"; \
		exit 1; \
	fi

run-hexbin:
	xxd -r -p img.hex > img.bin
	qemu-system-x86_64 -drive file=img.bin,format=raw
