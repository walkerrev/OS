SECTION MBR vstart=0x7c00

;section 用 vstart= 修饰后，可以被赋予一个虚拟起始地址

entry:
   mov ax,0x7c0
   mov ds,ax
   mov ax,0x9000
   mov es,ax
   mov cx,256
   sub si,si
   sub di,di
   rep
   movsw
   jmp 0x9000:(go-entry)
go:   :
   mov ax,cs
   mov ds,ax
   mov es,ax
   mov ss,ax
   mov fs,ax
   mov sp,0x9000

;bios中断  https://blog.csdn.net/weixin_37656939/article/details/79684611
;1、清屏操作
;INT 0x10  功能号：0x06  上卷窗口
;入口参数： mov [bx],ax
;AH 功能号= 0x06
;AL = 上卷的行数(如果为0,表示清窗口)
;BH = 上卷行属性
;(CL,CH) = 窗口左上角的(X,Y)位置
;(DL,DH) = 窗口右下角的(X,Y)位置
;无出口参数地质
;   mov ax,0x600
;   mov bx,0x700
;   mov cx,0
;   mov dx, 0x184f
;   int 0x10

;2、获取光标位置地址
   mov ah,3
   mov bh,0

   int 0x10


;3、打印字符串(Logo)
;AH   功能号=0x13
;AL   显示输出方式
;BH   页码
;BL   属性
;CX   字符串长度
;ES:BP  字符串地址
;(DH、DL)＝坐标((DH、DL)＝坐标(行、列)行、列)
   mov ax,0
   mov es,ax
   mov ax,message
   mov bp,ax
   mov cx,13
   mov ax,0x1301
   mov bx,0x2

   int 0x10

   mov ax,0x9000
   mov es,ax

;读取磁盘文件内容
   mov eax,0x2  ;起始扇区LBA地址

   ;LOADER_START_SECTOR equ 0x2
   
   mov bx,0x0200   ;写入的地址  
   ;LOADER_BASE_ADDR equ 0x90200 
   
   mov cx,4
   
   call read_disk_m_16

   jmp 0x9000:0x200

;  功能：读取硬盘扇区
read_disk_m_16:
   ;  eax = LBA 扇区号
   ;  ebx = 将数据写入的内存地址
   ;  ecx = 读入的扇区数
   mov esi,eax
   mov di,cx
;  读硬盘
;  第五步：从0x1f0端口读数据
   out dx,al
   mov eax,esi

;  第二步：将LBA地址存入0x1f3 ~ 0x1f6
   ;LBA地址7~0位写入端口0x1f3
   mov dx,0x1f3
   out dx,al
   ;LBA地址15~8位写入端口0x1f4
   mov cl,8
   shr eax,cl
   mov dx,0x1f4
   out dx,al
   ;LBA地址23~16位写入端口0x1f5
   shr eax,cl
   mov dx,0x1f5
   out dx,al
   shr eax,cl
   and al,0x0f ;LBA第24~27位
   or al,0xe0	;设置7～4位为1110,表示LBA模式
   mov dx,0x1f6
   out dx,al
;  第三步：向0x1f7端口写入读命令
   mov dx,0x1f7
   mov al,0x20
   out dx,al
;  第四步：检测硬盘状态
.not_ready:
   in al,dx
   and al,0x88
   cmp al,0x08
   jnz .not_ready

;第5步：从0x1f0端口读数据
   mov ax, di
   mov dx, 256
   mul dx
   mov cx, ax	   ; di为要读取的扇区数，一个扇区有512字节，每次读入一个字，共需di*512/2次，所以di*256
   mov dx, 0x1f0

.go_on_read:
   in ax,dx
   mov [bx],ax
   add bx,2
   loop .go_on_read
   ret

   message db "hello,linlin:"
   times 510-($-$$) db 0
   db 0x55,0xaa

;  $  隐式的指出当前行的地址
;  $$  指出本节区的起始地址

