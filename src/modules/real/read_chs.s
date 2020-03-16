read_chs:
    ; スタックフレームの構築
    push bp ; pushは16bitの幅でスタックに値をpushする
    mov bp, sp
    push 3 ; リトライ回数を積み込む
    push 0 ; 読み込みセクタ数

    ; レジスタの保存
    push bx
    push cx
    push dx
    push es ; セグメントレジスタ
    push si ; インデックスレジスタ

    ; 処理の開始（引数の取得） 
    mov si, [bp+4] ; 引数としての値が入る（パラメータバッファが入る）ベースとして用いる

    ; CXレジスタの設定（シリンダ番号の設定）
    mov ch, [si + drive.cyln + 0] ; 構造体から []であればメモリ参照
    mov cl, [si + drive.cyln + 1] ; 構造体から　8bitで区切りたいから+1
    shl cl, 6 ; 上位2ビットまでシフトレフトする（上位2ビットまでがシリンダなので）
    or cl, [si + drive.sect] ; cl = セクタ番号、セクタはオフセット+6になる。orで取ることで、残りの下位6bitにセクタ番号が入る。

    ; セクタ読み込み
    mov dh, [si + drive.head] ; 構造体から dhはヘッド、オフセット+4
    mov dl, [si + 0] ; dlはドライブ番号
    mov ax, 0x0000
    mov es, ax ; セグメントに0x0000を入れる。直は無理なのでaxを介して
    mov bx, [bp + 8] ; コピー先

.10L:
    mov ah, 0x02 ; int実行のための準備
    mov al, [bp + 6] ; セクタ数が入る

    int 0x13 ; BIOSコール
    jnc .11E ; CF=0の場合。読み込み失敗時はCF=1となる
    mov al, 0 ; 失敗時はここを通る
    jmp .10E

.11E:
    cmp al, 0 ; 
    jne .10E
    mov ax, 0
    dec word [bp - 2] ; デクリメント
    jnz .10L

.10E:
    mov ah, 0

    ; レジスタの復帰
    pop si
    pop es
    pop dx
    pop cx
    pop bx

    ; スタックフレームの破棄
    mov sp, bp
    pop bp

    ret