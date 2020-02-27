reboot:

  ; 再起動メッセージ
  cdecl puts, .s0
  ; キー入力待ち
.10L:
  mov ah, 0x10 ; 0x00な気がする AHレジスタへの入力が先
  int 0x16 ; No.5454参照 BIOSコール（キーボードサービス）
  cmp al, ' ' ; 空白の入力待ち

  jne .10L

  ; 改行の出力
  cdecl puts, .s1 ; 改行

  ; 再起動
  int 0x19 ; reboot。ahの入力はなし

  ; 文字列
.s0 db 0x0A, 0x0D, "Push SPACE key to reboot...", 0
.s1 db 0x0A, 0x0D, 0x0A, 0x0D, 0

