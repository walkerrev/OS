nasm -o mbr.bin mbr.s &&
dd if=./mbr.bin of=/home/walkerrevll/操作系统真相还原/bochs/bochs/bin/hd60M.img bs=512 count=1 conv=notrunc
