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

    ; CHS方式でセクタを読み出す No5523
    mov ah, 0x02 ; 固定
    mov al, 1 ; 読み込みセクタ数
    mov cx, 0x0002 ; CL->シリンダ番号（上位２ビット）CH->シリンダ番号（下位8ビット）No7319がわかりやすい 0~1023なので10bit使われる
    mov dh, 0x00 ; ヘッド番号 8ビット使う
    mov dl, [BOOT.DRIVE] ; ドライブ番号。起動時にBIOSから渡される
    mov bx, 0x7C00 + 512 ; 読み込み先の決め打ち
    int 0x13

.10Q: jnc .10E ; 出力として成功はCF=0, 失敗はCF=1なのでそこで条件分岐
.10T: cdecl puts, .e0
    call reboot

.10E:
    jmp stage_2 

    ; 数値を表示
    cdecl itoa, 8086, .s1, 8, 10, 0b0001
    cdecl puts, .s1 

    jmp $ ; 無限ループ

.s0 db "Booting...", 0x0A, 0x0D, 0 ; 長いので変数likeに定義 0Aで一行下げ、0Dはカーソルを左に戻す。0は文字列の終わりを示すため
.s1 db "--------", 0x0A, 0x0D, 0
.e0 db "Error:sector read", 0

ALIGN 2, db 0 ; No4209参照 2byte境界に配置する defaultではNOP命令が入るが、ここではdb 0を入れている

BOOT:

.DRIVE: dw 0 ; dwはnasmの疑似命令(Define word: 2byte)

%include "../modules/real/puts.s"
%include "../modules/real/itoa.s"
%include "../modules/real/reboot.s"

    times  510 - ($ - $$) db 0x00
    db 0x55, 0xAA

stage_2:
    ; 文字列の表示
    cdecl puts, .s0
    ; 処理の終了
    jmp $ ; 無限ループ
.s0 db "2nd stage...", 0x0A, 0x0D, 0

    ; パディング
    times (1024*8) - ($-$$) db 0 
