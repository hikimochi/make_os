BOOT_LOAD equ 0x7000 ; プログラムのロード位置 BOOT_LOAD定数に0x7000を入れる No4234参照
BOOT_SIZE equ (1024*8) ; ブートコードサイズ
SECT_SIZE equ (512) ; セクタサイズ
BOOT_SECT equ (BOOT_SIZE / SECT_SIZE) ; ブートプログラムのセクタ数
