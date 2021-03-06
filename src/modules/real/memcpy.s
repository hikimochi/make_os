memcpy:
  ; スタックフレームの構築
  push bp
  mov bp, sp ; bpを基準として設ける
  ; レジスタの保存
  push cx
  push si
  push di

  cld ; DFを0にすることでアドレスを加算する
  mov di,[bp+4] ; コピー先
  mov si,[bp+6] ; コピー元
  mov cx,[bp+8] ; バイト数

  rep movsb ; 実際のコピー処理 siの示すアドレスのデータをdiにコピー
  ; レジスタの復帰
  pop di
  pop si
  pop cx
  ; スタックフレームの破棄
  mov sp, bp ; bpの値をspに戻す
  pop bp

  ret ; 呼び出し元に戻る