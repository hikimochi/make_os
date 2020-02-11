; boot parameter blockをNOPで埋める

BOOT_LOAD equ 0x7C00 ; BOOT_LOAD定数に0x7000を入れる No4234参照

ORG BOOT_LOAD

entry:
    jmp ipl ; initial program loaderへジャンプ

    times  90 - ($ - $$) db 0x90 ; 90byte文をNOP(0x90)で埋める

ipl: ; initial program loader

    cli ; 割り込み禁止、初期化時に割り込みしてほしくない

    mov ax, 0x0000 ; 汎用レジスタに即値を入れる
    ; セグメントレジスタの初期化
    mov ds, ax
    mov es, ax
    mov ss, ax

    mov sp, BOOT_LOAD ; スタックポインタは即値を入れられる

    sti ; 割り込み許可

    mov [BOOT.DRIVE], dl ; ブートドライブの保存 dlはデータレジスタ,BIOSからすでに値が渡されている

    mov al, 'A'

    mov ah, 0x0E
    mov bx, 0x0000
    int 0x10 ; BIOSコール　文字表示 No5485を参照

    jmp $ ; 無限ループ

ALIGN 2, db 0 ; No4209参照 2byte境界に配置する defaultではNOP命令が入るが、ここではdb 0を入れている

BOOT:

.DRIVE: dw 0 ; dwはnasmの疑似命令(Define word: 2byte)

    times  510 - ($ - $$) db 0x90
    db 0x55, 0xAA