; boot parameter blockをNOPで埋める

BOOT_LOAD equ 0x7C00 ; BOOT_LOAD定数に0x7000を入れる No4234参照

ORG BOOT_LOAD

; マクロ
%include "../include/macro.s"

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

    ; 文字列表示
    cdecl puts, .s0

    ; 数値を表示
    cdecl itoa, 8086, .s1, 8, 10, 0b0001
    cdecl puts, .s1 

    cdecl itoa, 8086, .s1, 8, 10, 0b0011
    cdecl puts, .s1 

    cdecl itoa, -8086, .s1, 8, 10, 0b0001
    cdecl puts, .s1

    cdecl itoa, -1, .s1, 8, 10, 0b0001
    cdecl puts, .s1

    cdecl itoa, -1, .s1, 8, 10, 0b0000
    cdecl puts, .s1

    cdecl itoa, -1, .s1, 8, 16, 0b0000
    cdecl puts, .s1

    cdecl itoa, 12, .s1, 8, 2, 0b0100
    cdecl puts, .s1

    jmp $ ; 無限ループ

.s0 db "Booting...", 0x0A, 0x0D, 0 ; 長いので変数likeに定義 0Aで一行下げ、0Dはカーソルを左に戻す。0は文字列の終わりを示すため
.s1 db "--------", 0x0A, 0x0D, 0

ALIGN 2, db 0 ; No4209参照 2byte境界に配置する defaultではNOP命令が入るが、ここではdb 0を入れている

BOOT:

.DRIVE: dw 0 ; dwはnasmの疑似命令(Define word: 2byte)

%include "../modules/real/puts.s"
%include "../modules/real/itoa.s"

    times  510 - ($ - $$) db 0x00
    db 0x55, 0xAA