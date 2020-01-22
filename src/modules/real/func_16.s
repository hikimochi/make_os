; int func_16(int x, int y) # 引数x, y 戻り値として1を返す関数
; callは次に実行する命令のアドレスを戻り番地としてスタックに積み込み、指定されたアドレスへとジャンプする

func_16:

  ; 関数が必要とする引数の積み込みは関数を呼び出す側が行う
  push  bp ; スタックに積み込む
  mov  bp, sp ;
  sub  sp, 2  ;
  push  0  ;
  mov  [bp-2], word 10 ;
  mov  [bp-4], word 20 ;
  mov  ax, [bp+4]  ;
  add  ax, [bp+6]  ;
  mov  ax, 1  ;
  mov  sp, bp  ;
  pop  bp
  ret