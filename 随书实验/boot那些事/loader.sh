nasm -o loader.bin loader.s &&
dd if=./loader.bin of=/home/walkerrevll/操作系统真相还原/bochs/bochs/bin/hd60M.img bs=512 count=1 seek=2 conv=notrunc