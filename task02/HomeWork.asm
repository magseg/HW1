; вариант 5: Разработать программу, которая вводит одномерный массив A[N], формирует из элементов массива A новый массив B из элементов A, значение
; которых не совпадает с введённым числом x.

format PE console
entry start

include 'win32a.inc'

;--------------------------------------------------------------------------
section '.data' data readable writable

        strVecSize     db 'size of vector: ', 0
        strIncorSize   db 'Incorrect size of vector = %d', 10, 0
        strVecElemI    db '[%d]? ', 0
        strScanInt     db '%d', 0
        strX           db 'x = ', 0
        strXOutput db 'number x in A: ', 0
        strBVec        db '---B---', 10, 0
        strVecElemOut  db '[%d] = %d', 10, 0
        newline db '', 10, 0

        vec_size     dd 0
        x            dd 0
        count        dd 0
        i            dd ?
        tmp          dd ?
        tmp_b        dd ?
        vec          rd 100
        vecB         rd 100

;--------------------------------------------------------------------------
section '.code' code readable executable
start:
; 1) vector input
        call VectorInput
; 2) x input
        call XInput
; 3) Подсчёт кол-ва элементов в A, равных x
        call VectorReady ; подготовка к проходу по массиву
        call VectorAScan ; подсчёт кол-ва элементов в A, равных x
        call XWrite
; 4) Заполнение массива B
        call VectorReady ; подготовка к проходу по массиву
        call FillB
; 5) vectorB output
        call VectorReady ; подготовка к проходу по массиву
        call ReturnB ; вывод массива B

        finish:
        call [getch]

        push 0
        call [ExitProcess]
;----------------------------------------------------------------------
VectorInput:
        push strVecSize
        call [printf]
        add esp, 4

        push vec_size
        push strScanInt
        call [scanf]
        add esp, 8

        mov eax, [vec_size] ;В регистр eax помещаем размер массива A
        cmp eax, 0 ;Сравниваем размер массива с 0
        jg  getVector  ;если больше, то переходим к метке getVector, иначе идем дальше (и завершаем программу)

; fail size
        push [vec_size]
        push strIncorSize
        call [printf]
        call [getch]
        push 0
        call [ExitProcess]
; else continue...
getVector:
        xor ecx, ecx            ; ecx = 0
        mov ebx, vec            ; ebx = &vec
getVecLoop:
        mov [tmp], ebx
        cmp ecx, [vec_size]      ; ecx - счётчик введённого кол-ва элементов
        jge endInputVector       ; если он больше или равен ко-ву элементов массива, то переходим на метку endInputVector

        ; input element
        mov [i], ecx
        push ecx
        push strVecElemI
        call [printf]
        add esp, 8

        push ebx
        push strScanInt
        call [scanf]
        add esp, 8

        mov ecx, [i]
        inc ecx
        mov ebx, [tmp]
        add ebx, 4
        jmp getVecLoop
endInputVector:
        mov ebx, vec
        xor ecx, ecx
        ret
;----------------------------------------------------------------
XInput:
        push strX
        call [printf]
        add esp, 4

        push x
        push strScanInt
        call [scanf]
        add esp, 8
        ret
;----------------------------------------------------------------
VectorReady:
        xor ecx, ecx
        mov [i], 0
        xor eax, eax
        mov ebx, vec                 ; ebx = &vec
        mov edx, vecB                ; edx = &vecB
        ret

VectorAScan:
        cmp ecx, [vec_size]
        jge endScanVector
        mov eax, [ebx]
        cmp eax, [x]
        je plusOneToCount
        inc ecx
        add ebx, 4
        jmp VectorAScan

plusOneToCount:
        inc [count]
        inc ecx
        add ebx, 4
        jmp VectorAScan

endScanVector:
        ret
XWrite:
       push strXOutput
       call [printf]
       add esp, 4
       push [count]
       push strScanInt
       call [printf]
       add esp, 8
       push newline
       call [printf]
       add esp, 4
       ret
;----------------------------------------------------------------
FillB:
       cmp ecx, [vec_size]
       jge endScanVector
       mov eax, [ebx]
       cmp eax, [x]
       jne addElement
       add ebx, 4
       add ecx, 1
       jmp FillB

addElement:
        mov [edx], eax
        add edx, 4
        add ebx, 4
        add ecx, 1
        mov [i], ecx
        jmp FillB
;----------------------------------------------------------------
ReturnB:
        mov [tmp], ecx
        push strBVec
        call [printf]
        mov ecx, [tmp]
        mov edx, vecB
        add esp, 4
        mov eax, [vec_size]
        sub eax, [count]
BLoad:
        cmp ecx, eax
        jge theEnd
        mov [tmp], ecx
        mov [tmp_b], eax
        mov [i], edx
        push dword [edx]
        push ecx
        push strVecElemOut
        call [printf]
        add esp, 8
        mov ecx, [tmp]
        mov eax, [tmp_b]
        mov edx, [i]
        add edx, 4
        add ecx, 1
        jmp BLoad
theEnd:
        jmp finish
;-------------------------------third act - including HeapApi--------------------------
                                                 
section '.idata' import data readable
    library kernel, 'kernel32.dll',\
            msvcrt, 'msvcrt.dll',\
            user32,'USER32.DLL'

include 'api\user32.inc'
include 'api\kernel32.inc'
    import kernel,\
           ExitProcess, 'ExitProcess',\
           HeapCreate,'HeapCreate',\
           HeapAlloc,'HeapAlloc'
  include 'api\kernel32.inc'
    import msvcrt,\
           printf, 'printf',\
           scanf, 'scanf',\
           getch, '_getch'                                    