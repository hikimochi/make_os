memcpy: ; 32bitレジスタの使用
  ; スタックフレームの構築
  push ebp
  mov ebp, esp ; bpを基準として設ける
  ; レジスタの保存
  push ecx
  push esi
  push edi

  cld ; DFを0にすることでアドレスを加算する
  mov edi,[ebp+8] ; コピー先
  mov esi,[ebp+12] ; コピー元
  mov ecx,[ebp+16]　; バイト数

  rep movsb ; 実際のコピー処理 siの示すアドレスのデータをdiにコピー
  ; レジスタの復帰
  pop edi
  pop esi
  pop ecx
  ; スタックフレームの破棄
  mov esp, ebp ; bpの値をspに戻す
  pop ebp

  ret ; 呼び出し元に戻る