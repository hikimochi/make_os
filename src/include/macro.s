%macro cdecl 1-*.nolist

  %rep %0 - 1
    push %{-1:-1}
    %rotate -1
  %endrep
  %rotate -1

    call %1

  %if 1 < %0
    add sp, (__BITS__ >> 3) * (%0 - 1)
  %endif

%endmacro

struc drive ; No4696の構造体を参照 strucとendstrucで囲む 構造体はスタックを模している。ラベルとは別物
    .no  resw 1 ; reswは2byte ラベル、データ型、要素数の意
    .cyln resw 1 ; オフセットは+2(16bit)
    .head resw 1
    .sect resw 1
endstruc  



