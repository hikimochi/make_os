; マクロ
%include "../include/define.s"
%include "../include/macro.s"

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

    mov [BOOT + drive.no], dl ; ブートドライブの保存 dlはデータレジスタ,BIOSからすでに値が渡されている、BOOTは構造体の始まりのアドレス

    ; 文字列表示
    cdecl puts, .s0

    ; 残りのセクタをすべて読み込む
    mov bx, BOOT_SECT - 1 ; BX = 残りのブートセクタ数
    mov cx, BOOT_LOAD + SECT_SIZE ; CX = 次のアドレス

    cdecl read_chs, BOOT, bx, cx ; AX = read_chs(BOOT, BX, CX)

    cmp ax, bx 

.10Q: 
    jz .10E
.10T: 
    cdecl puts, .e0 ; error文言
    call reboot
.10E:
    jmp stage_2

.s0 db "Booting...", 0x0A, 0x0D, 0 ; 長いので変数likeに定義 0Aで一行下げ、0Dはカーソルを左に戻す。0は文字列の終わりを示すため
.e0 db "Error:sector read", 0

ALIGN 2, db 0 ; No4209参照 2byte境界に配置する defaultではNOP命令が入るが、ここではdb 0を入れている
BOOT:
    istruc drive
        at drive.no, dw 0 ; ドライブ番号
        at drive.cyln, dw 0 ; C: シリンダ
        at drive.head, dw 0 ; H: ヘッド
        at drive.sect, dw 2 ; S: セクタ
    iend

%include "../modules/real/puts.s"
%include "../modules/real/reboot.s"
%include "../modules/real/read_chs.s"

    times  510 - ($ - $$) db 0x00
    db 0x55, 0xAA

stage_2:
    ; 文字列の表示
    cdecl puts, .s0
    ; 処理の終了
    jmp $ ; 無限ループ

.s0 db "2nd stage...", 0x0A, 0x0D, 0

    ; パディング
    times BOOT_SIZE - ($ - $$) db 0 