build:
	xxd -r -p img.hex > img.bin

run:
	qemu-system-x86_64 -drive file=img.bin,format=raw
