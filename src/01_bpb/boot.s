; boot parameter blockをNOPで埋める
entry:
    jmp ipl ; initial program loaderへジャンプ

    times  90 - ($ - $$) db 0x90 ; 90byte文をNOP(0x90)で埋める

ipl: ; initial program loader
    jmp $ ; 無限ループ

    times  510 - ($ - $$) db 0x90
    db 0x55, 0xAA
