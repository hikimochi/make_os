memcmp:
  ; スタックフレームの構築
  push bp
  mov bp sp
  ; レジスタの保存
  push bx
  push cx
  push dx
  push si
  push di
  ; 引数の取得
  cld
  mov si, [bp+4] ; 引数1
  mov di, [bp+6] ; 引数2
  mov cx, [bp+8] ; バイト数
  ; バイト単位での比較
  repe cmpsb
  jnz .10F ; 一致しないときは .10Fへ
  mov ax, 0 ; 一致するときは0になる（一致しないときは.10Fに飛ぶので）
  jmp .10E ; 

.10F
  mov ax, -1 

.10E
  ; レジスタを破棄
  pop di
  pop si
  pop dx
  pop cx
  pop bx
  ; スタックフレームの破棄
  mov sp, bp
  pop bp

  ret ; 呼び出し元に戻る
