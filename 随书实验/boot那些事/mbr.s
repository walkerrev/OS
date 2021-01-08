;主引导程序
SECTION MBR vstart=0x7c00
;section 用 vstart= 修饰后，可以被赋予一个虚拟起始地址
   mov ax,cs
   mov ds,ax
   mov es,ax
   mov ss,ax
   mov fs,ax
   mov sp,0x7c00

;bios中断  https://blog.csdn.net/weixin_37656939/article/details/79684611
;1、清屏操作
;INT 0x10  功能号：0x06  上卷窗口

;入口参数：

;AH 功能号= 0x06
;AL = 上卷的行数(如果为0,表示清窗口)
;BH = 上卷行属性
;(CL,CH) = 窗口左上角的(X,Y)位置
;(DL,DH) = 窗口右下角的(X,Y)位置
;无出口参数地质

;   mov ax,0x600
;   mov bx,0x700
;   mov cx,0
;   mov dx,0x184f

;   int 0x10

;2、获取光标位置
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

   mov ax,message
   mov bp,ax

   mov cx,13
   mov ax,0x1301
   mov bx,0x2
   int 0x10


   jmp $;  无限循环

   message db "hello,linlin:"
   times 510-($-$$) db 0
   db 0x55,0xaa

;  $  隐式的指出当前行的地址
;  $$  指出本节区的起始地址

