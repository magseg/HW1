;Вариант 26. Разработать программу, вычисляющую с помощью степенного ряда с точностью не хуже 0,05% значение функции cos(x) для заданного параметра x (использовать FPU)
;Выполнил Скарлупин Максим Олегович
format PE console ; Консольное приложение для Windows
entry start ; устанавливаем точку входа - start

include 'win32ax.inc'
;--------------------------------Variable initialization------------------------------------------
section '.data' data readable writeable
    strX db 'x = ', 0 ; строка для вывода в консоль
    formatF     db    '%lf', 0
    x dq 0.0 ; переменная для записи значения x
    output db 256  dup(?) ; строка для вывода по формату
;--------------------------------Variable initialization------------------------------------------
;--------------------------------Main program----------------------------------------------------
section '.code' code executable

start:
    MainProcedure: ; основная процедура - считает значение cos(x)
        call ReadX ; считывание x
        call cosX ; вычисление cos(x). Значение находится в x
    jmp Show ; переходим на вывод результата

cosX:
    FINIT ; инициализация сопроцессора
    fld [x] ; заносим значение x в регистр ST(0)
    FCOS ; вычисляем cos(ST(0))
    FST [x] ; заносим значение косинуса в x
    ret

ReadX: ; функция считывания x
    push strX ; заносим строку "x = " в стек
    call [printf] ; выводит на экран "x = "
    add esp, 4

    push x
    push formatF
    call [scanf] ; считываем x
    add esp, 8
    ret

Show: ; функция для вывода результата
    invoke sprintf, output, 'cos(x) = %.4f', dword[x], dword[x+4] ; формируем строку вывода
    call [printf] ; вызов вывода cos(x)
    call [getch] ; вызов getch для того, чтобы консоль не закрылась сразу
    push 0
    call [ExitProcess] ; завершение программы
;--------------------------------Main program----------------------------------------------------

;--------------------------------Libraries-------------------------------------------------------
section '.idata' data readable import
    library kernel32, 'kernel32.dll', \
       msvcrt, 'msvcrt.dll', \
       user32, 'USER32.dll'
    import kernel32,\
        ExitProcess, 'ExitProcess'
    import msvcrt,\
        printf, 'printf',\
        scanf, 'scanf',\
        sprintf, 'sprintf',\
        getch, '_getch'
;--------------------------------Libraries-------------------------------------------------------