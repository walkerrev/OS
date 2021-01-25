SECTION Loader vstart=0x90200

jmp loader_start

loader_start:
    mov sp,0x0200
    mov bp,loadermsg
    mov cx,7
    mov ax,0x1301
    mov bx,0x001f
    mov dx,0x1800
    int 0x10

;  准备进入保护模式
;  打开A20

;    in al,0x92
;    or al,0000_0010B
;    out 0x92,al

;  加载GDT

;    lgdt [gdt_ptr]

;  cr0第0位置

;    mov eax,cr0
;    or eax,0x00000001
;    mov cr0,eax

    jmp $



    loadermsg db "loader:"






