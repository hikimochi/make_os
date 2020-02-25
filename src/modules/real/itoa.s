itoa:

  ; スタックフレーム
  push bp
  mov bp, sp

  ; レジスタの保存
  push ax
  push bx
  push cx
  push dx
  push si ; ソースレジスタ
  push di ; destinationレジスタ

  ; 引数の取得
  mov ax, [bp+4] ; 数値
  mov si, [bp+6] ; バッファアドレス
  mov cx, [bp+8] ; 残りバッファサイズ
  mov di, si ; バッファの最後尾をdiへ
  add di, cx ; バッファアドレス分足す
  dec di ; 1減算する
  mov bx, word [bx+12] ; フラグ

  ; 符号付き判定
  test bx, 0b0001 ; フラグの最下位ビットを確認,符号付き整数か確認、ANDが成立すればゼロフラグが立つ
.10Q: je .10E ; ゼロフラグが立っていればjmp
  cmp ax, 0 ; axから0を引き結果をaxに保存。0であればフラグも立つ
.12Q: jge .12E ; 13.1(No6247参照) 符号付き演算での条件分岐
  or bx, 0b0010 ; 論理和演算し、bxに格納
.12E:
.10E:

  ; 符号出力判定
  test bx, 0b0010 ; フラグの第２ビットを確認,符号出力するか確認、ANDが成立すればゼロフラグが立つ
.20Q: je .20E
  cmp ax, 0 
.22Q: jge .22F
  neg ax ; 符号反転
  mov [si], byte '-' ; '-'という文字列を先頭に追加
  jmp .22E
.22F:
  mov [si], byte '+' ; '+'という文字列を先頭に追加
.22E:
  dec cx ; バッファの減算
.20E:

  ; ASCII変換
  mov bx, [bp+10] ; 基数
.30L:
  mov dx, 0 ; 初期化
  div bx ; 基数の余りがdxに入る、axには商が入る
  mov si, dx ; テーブルを参照する
  mov dl, byte [.ascii + si] ; dlにascii[index]が入る
  mov [di], dl ; destinationの番地にdlが入る
  dec di ; 1文字（数字）減算
  cmp ax, 0
  loopnz .30L ;
.30E:

  ; 空欄埋め
  cmp cx, 0
.40Q: je .40E
  mov al, ' ' ; 空白で埋める
  cmp [bp+12], word 0b0100 ; 第3ビット確認
.42Q: jne .42E
  mov al, '0' ; 0で埋める
.42E:
  std
  rep stosb
.40E:

  ; レジスタの復帰
  pop di
  pop si
  pop dx
  pop cx
  pop bx
  pop ax

  ; スタックフレームの破棄
  mov sp, bp
  pop bp

  ret

; 変換テーブル
.ascii db "0123456789ABCDEF"




