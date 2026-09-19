; nasm -f elf64 perfectSquare.asm && gcc -no-pie perfectSquare.o -o perfectSquare -lm


section .data
    fmt_result  db "%d", 10, 0
    fmt_error   db "Error: Invalid input", 10, 0
    buffer      times 4096 db 0

section .bss
    count       resq 1

section .text
    global main
    extern printf, fgets, strtoll, sqrt, stdin

main:
    push rbp
    mov rbp, rsp
    sub rsp, 32
    
    mov qword [count], 0


read_next_line:
    mov rdi, buffer
    mov rsi, 4096
    mov rdx, [stdin]
    call fgets
    
    test rax, rax
    jz print_result
    
    ; Проверка на пустую строку
    mov al, [buffer]
    cmp al, 10
    je print_result


    mov rdi, buffer
    
replace_commas:
    mov al, [rdi]
    test al, al
    jz parse_tokens
    cmp al, ','
    jne skip_replace
    mov byte [rdi], ' '
skip_replace:
    inc rdi
    jmp replace_commas

parse_tokens:
    mov r12, buffer      ; r12 = текущая позиция в строке

token_loop:
    ; Пропускаем пробелы
    call skip_spaces
    
    ; Проверяем конец строки
    mov al, [r12]
    test al, al
    jz read_next_line
    cmp al, 10           ; '\n'
    je read_next_line
    
    ; Нашли начало токена
    mov r13, r12         ; r13 = начало токена
    
    ; Ищем конец токена
    call find_token_end
    
    ; Заменяем пробел/конец строки на 0 (терминатор для strtoll)
    mov al, [r12]
    mov byte [r12], 0    ; Временно ставим 0
    push rax             ; Сохраняем оригинальный символ
    
    ; Конвертируем токен в число
    mov rdi, r13         ; Начало токена
    mov rsi, 0           ; endptr = NULL
    mov rdx, 10          ; основание = 10
    call strtoll
    
    mov r14, rax         ; r14 = число
    
    ; Восстанавливаем символ
    pop rax
    mov [r12], al
    
    ; Проверяем на отрицательное
    cmp r14, 0
    jl parse_error
    
    ; Проверяем на полный квадрат
    mov rdi, r14
    call check_square
    
    cmp rax, 1
    jne skip_increment
    inc qword [count]
    
skip_increment:
    inc r12              ; Переходим к следующему символу
    jmp token_loop

skip_spaces:
    mov al, [r12]
    cmp al, ' '
    je skip_one
    cmp al, 9            ; табуляция
    je skip_one
    ret
skip_one:
    inc r12
    jmp skip_spaces


find_token_end:
    mov al, [r12]
    test al, al          ; конец строки
    jz found_end
    cmp al, 10           ; \n
    je found_end
    cmp al, ' '
    je found_end
    cmp al, 9            ; табуляция
    je found_end
    inc r12
    jmp find_token_end
found_end:
    ret

check_square:
    push rbp
    mov rbp, rsp
    
    cmp rdi, 0
    jl not_square
    
    ; sqrt(n)
    cvtsi2sd xmm0, rdi
    call sqrt
    cvttsd2si rax, xmm0     ; truncate
    
    mov rcx, rax             ; rcx = sqrt_n
    mov r8, rdi              ; r8 = n
    
    ; Проверка sqrt_n * sqrt_n == n
    mov rax, rcx
    imul rax, rax
    cmp rax, r8
    je is_square
    
    ; Проверка (sqrt_n + 1)^2 == n
    mov rax, rcx
    inc rax
    imul rax, rax
    cmp rax, r8
    je is_square
    
    ; Проверка (sqrt_n - 1)^2 == n
    mov rax, rcx
    dec rax
    imul rax, rax
    cmp rax, r8
    je is_square
    
not_square:
    mov rax, 0
    leave
    ret

is_square:
    mov rax, 1
    leave
    ret


print_result:
    mov rsi, [count]
    mov rdi, fmt_result
    xor eax, eax
    call printf
    
    xor eax, eax
    leave
    ret

parse_error:
    mov rdi, fmt_error
    call printf
    mov rax, 1
    leave
    ret