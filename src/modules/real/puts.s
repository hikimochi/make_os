puts:
  ; スタックフレーム 
  push bp
  mov bp, sp

  ; レジスタの保存
  push ax
  push bx
  push si

  ; 引数の取得
  mov si, [bp+4]

  ; 処理の開始
  mov ah, 0x0E ; テレタイプ式1文字
  mov bx, 0x0000
  cld ; DF=0に

.10L: ; ラベル
  lodsb
  cmp al, 0
  je .10E ; jump equal

  int 0x10 ; BIOSコールで割り込み
  jmp .10L

.10E: ; 残りの文字が0になったらここに飛ぶ

  ; レジスタの復帰
  pop si
  pop bx
  pop ax
  ; スタックフレームの破棄
  mov sp, bp
  pop bp

  ret