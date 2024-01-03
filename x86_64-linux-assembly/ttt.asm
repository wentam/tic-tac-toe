;; rax rcx rdx rbx rsp rbp rsi rdi r8 r9 r10 r11 r12 r13 r14 r15
;; rsp: stack pointer
;; callee preserve registers: rbp, rbx, r12, r13, r14, r15

section .text
global _start

section .data
board_state: db '         ' ; 9 chars

section .rodata
stdout_fd: equ 1
stdin_fd: equ 0
welcome_msg:      db  "Welcome!",10
welcome_msg_len:  equ $ - welcome_msg
empty_row: db '   ' ; 3 chars

player_x_prompt: db "Player 1/X [1-9]: "
player_x_prompt_len: equ $ - player_x_prompt

player_o_prompt: db "Player 2/O [1-9]: "
player_o_prompt_len: equ $ - player_o_prompt

invalid_input_msg: db "Invalid input, must be 1-9",10
invalid_input_msg_len: equ $ - invalid_input_msg

win_msg: db " wins!",10
win_msg_len: equ $ - win_msg

stalemate_msg: db "stalemate!",10
stalemate_msg_len: equ $ - stalemate_msg

;; Syscall numbers
sys_write: equ 0x01
sys_read:  equ 0x00
sys_exit:  equ 0x3c

section .text

;; rcx: char
;; rdi: output fd
putc: dec rsp
      mov byte [rsp], cl
      mov rdx, 1
      mov rsi, rsp
      ; output fd already specified in rdi
      mov rax, sys_write
      inc rsp
      syscall
      ret

;; rdx: length
;; rcx: byte
;; rdi: output fd
output_byte_n_times: mov r8, rsp         ; Save the stack pointer to restore later
                     mov r9, 0           ; Loop index
    fill_stack_loop: dec rsp             ; move to fresh byte in stack
                     mov byte [rsp], cl  ; cl = rcx last byte
                     inc r9              ; increment index
                     cmp r9, rdx         ; Loop end condition
                     jne fill_stack_loop ; ^^^^

                     ; sys_write call
                                        ; length for syscall is already in rdx
                     mov rsi, rsp       ; pointer to the string to write
                                        ; output fd already specified in rdi
                     mov rax, sys_write ; syscall to use
                     syscall

                     mov rsp, r8 ; Restore the stack pointer
                     ret

;; rax: pointer to 3-element array of data for this row. 'X', 'O', or ' '
render_board_row: push rbp ; Perserve rbp
                  push r13 ; Perserve r13
                  mov rbp, rax ; Move array pointer to callee-preserve register

                  ;; Output vertical bar
                  mov r13, 0 ; Loop index
            cell: mov rdi, stdout_fd
                  mov rcx, '|'
                  call putc

                  ;; Output space to data char
                  mov rdx, 2
                  mov rcx, ' '
                  call output_byte_n_times

                  ;; Output data char
                  mov rdx, 1
                  mov rsi, rbp ; Pointer to string to write
                  mov rdi, stdout_fd
                  mov rax, sys_write
                  syscall

                  ;; Output space to next cell
                  mov rdx, 2
                  mov rcx, ' '
                  call output_byte_n_times

                  ;; Increment index, char pointer
                  inc r13
                  inc rbp

                  ;; Loop exit condition
                  cmp r13, 3
                  jne cell

                  ;; Close the row
                  mov rdi, stdout_fd
                  mov rcx, '|'
                  call putc

                  ;; Newline
                  mov rcx, 10
                  mov rdi, stdout_fd
                  call putc

                  pop r13 ; Perserve r13
                  pop rbp ; Perserve rbp
                  ret

render_board: push r13 ; Preserve r13
              push r14 ; Preserve r14

              ;; Loop to render row-by-row

              mov r13, 0 ; Loop index
              mov r14, board_state ; Board state index, to be moved 3 at a time
         row: ;; Output a horizonal bar
              mov rdx, 19
              mov rcx, '-'
              mov rdi, stdout_fd
              call output_byte_n_times

              ;; Newline
              mov rcx, 10
              mov rdi, stdout_fd
              call putc

              ;; Empty Row
              mov rax, empty_row
              call render_board_row

              ;; Data Row
              mov rax, r14
              call render_board_row

              ;; Empty Row
              mov rax, empty_row
              call render_board_row

              ;; Increment
              inc r13
              add r14, 3

              ;; Loop exit condition
              cmp r13, 3
              jne row

              ;; Closing horizontal bar
              mov rdx, 19
              mov rcx, '-'
              mov rdi, stdout_fd
              call output_byte_n_times

              ;; Newline
              mov rcx, 10
              mov rdi, stdout_fd
              call putc

              pop r14 ; Preserve r14
              pop r13 ; Preserve r13
              ret

;; rsi: prompt string
;; rdx: prompt string length
;;
;; after return, rax contains user's input as 0-8
prompt_user_for_number: ;; Print prompt
                        push rsi
                        push rdx
                        push r13

                        mov rdi, stdout_fd
                        mov rax, sys_write
                        syscall

                        ;; Read user input into r13
                        mov rsi, rsp ; We'll write the output to ...
                        dec rsi      ; the next available byte in the stack
                        mov rdx, 1   ; Read one byte
                        mov rax, sys_read
                        mov rdi, stdin_fd
                        syscall
                        mov r13, [rsp-1]

                        ;; Continue to read until a newline is found to consume
                        ;; the rest of the line
           flush_stdin: mov rsi, rsp
                        dec rsi
                        mov rdx, 1
                        mov rax, sys_read
                        mov rdi, stdin_fd
                        syscall
                        cmp byte [rsp-1], 10
                        jne flush_stdin

                        ;; Validate input.
                        ;; 49-57 are ascii codes for 1-9
                        cmp r13, 48
                        jle invalid_input
                        cmp r13, 58
                        jge invalid_input

                        mov rax, r13
                        sub rax, 49
                        pop r13
                        pop rdx
                        pop rsi
                        ret

                        ;; Invalid input trap
         invalid_input: mov rdx, invalid_input_msg_len
                        mov rsi, invalid_input_msg
                        mov rdi, stdout_fd
                        mov rax, sys_write
                        syscall

                        pop r13
                        pop rdx
                        pop rsi
                        jmp prompt_user_for_number

;; rax: the winner as 'X' or 'O' - numeric 0 if no winner yet
check_win: ;; Check rows
           mov r11, 0 ; board_state ptr
check_row: mov r10b, byte[board_state+r11]
           sub r10b, byte[board_state+r11+1]
           mov r9b, byte[board_state+r11+1]
           sub r9b, byte[board_state+r11+2]
           or r10b, r9b
           mov r9b, ' '
           cmp r9b, byte[board_state+r11]
           sete r9b
           or r10b, r9b
           je win

           add r11, 3
           cmp r11, 9
           jne check_row

           ;; Check columns
           mov r11, 0
check_col: mov r10b, byte[board_state+r11]
           sub r10b, byte[board_state+r11+3]
           mov r9b, byte[board_state+r11+3]
           sub r9b, byte[board_state+r11+6]
           or r10b, r9b
           mov r9b, ' '
           cmp r9b, byte[board_state+r11]
           sete r9b
           or r10b, r9b
           je win

           inc r11
           cmp r11, 3
           jne check_col

           ;; Check diagnals
           mov r10b, byte[board_state]
           sub r10b, byte[board_state+4]
           mov r9b, byte[board_state+4]
           sub r9b, byte[board_state+8]
           mov r11, 0
           or r10b, r9b
           mov r9b, ' '
           cmp r9b, byte[board_state]
           sete r9b
           or r10b, r9b
           je win

           mov r10b, byte[board_state+2]
           sub r10b, byte[board_state+4]
           mov r9b, byte[board_state+4]
           sub r9b, byte[board_state+6]
           mov r11, 2
           or r10b, r9b
           mov r9b, ' '
           cmp r9b, byte[board_state+2]
           sete r9b
           or r10b, r9b
           je win

           mov rax, 0
           ret

  win: mov rax, 0
           mov al, byte[board_state+r11]
           ret

;; used to check for stalemate
;; rax will be 0 if not filled, 1 if filled
check_board_filled: mov r11, 0
        check_loop: cmp byte[board_state+r11], ' '
                    je not_filled
                    inc r11
                    cmp r11, 9
                    jne check_loop

                    mov rax, 1
                    ret
        not_filled: mov rax, 0
                    ret

main_loop: ;; Render the board
           call render_board

           ;; Check for win
           call check_win
           cmp rax, 0
           jne winner

           ;; Check for stalemate
           call check_board_filled
           cmp rax, 1
           je stalemate

           ;; Prompt player x for a number
   x_turn: mov rsi, player_x_prompt
           mov rdx, player_x_prompt_len
           call prompt_user_for_number

           cmp byte[board_state + rax], ' '
           jne x_turn

           ;; Update board state according to user's input
           mov byte[board_state + rax], 'X'

           ;; Re-render board
           call render_board

           ;; Check for win
           call check_win
           cmp rax, 0
           jne winner

           ;; Check for stalemate
           call check_board_filled
           cmp rax, 1
           je stalemate

           ;; Prompt player o for a number
   o_turn: mov rsi, player_o_prompt
           mov rdx, player_o_prompt_len
           call prompt_user_for_number

           cmp byte[board_state + rax], ' '
           jne o_turn

           ;; Update board state according to user's input
           mov byte[board_state + rax], 'O'

           jmp main_loop
           ret
   winner: ;; Output winner's letter
           mov rcx, rax
           mov rdi, stdout_fd
           call putc

           ;; Output " wins!"
           mov rdx, win_msg_len
           mov rsi, win_msg
           mov rdi, stdout_fd
           mov rax, sys_write
           syscall
           ret
stalemate: mov rdx, stalemate_msg_len
           mov rsi, stalemate_msg
           mov rdi, stdout_fd
           mov rax, sys_write
           syscall
           ret

_start: ;; Output welcome string
        mov rdx, welcome_msg_len ; message length
        mov rsi, welcome_msg     ; message to write
        mov rdi, stdout_fd
        mov rax, sys_write
        syscall

        ;; Main loop
        call main_loop

        ;; Exit
        mov rdi, 0        ; exit code
        mov rax, sys_exit ; system call number (sys_exit)
        syscall           ; call kernel
