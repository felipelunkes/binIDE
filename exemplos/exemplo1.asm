[bits 16]   ;; Define que o aplicativo deve ser 16 Bits
[org 0]     ;; Organiza o Offset para 0


inicio:     ;; Aqui se inicia o aplicativo

mov ax,cs   ;; Ajusta a área de memória a ser executado o aplicativo
mov ds,ax
mov es,ax


mov si, boasvindas
call escrever

mov si, tecla
call escrever

call aguardartecla


jmp fim      ;; Pula para o fim do aplicativo


;;******************************************************************


escrever:            ;; Driver para imprimir caracteres na tela


;; Use este driver para escrever caracteres na tela utilizando o Bin S.O

;; Sintaxe desta função:

;;mov si, mensagem ou registrador
;;call escrever


lodsb

or al, al
jz .pronto

mov ah, 0x0E
int 0x10

jmp escrever


.pronto:
ret


clrscr:                      ;; Processo para limpar a tela


push ax
push bx
push cx
push dx


mov dx, 0
mov bh, 0
mov ah, 2
int 10h

mov ah, 6
mov al, 0
mov bh, 7
mov cx, 0
mov dh, 24
mov dl, 79
int 10h


pop dx
pop cx
pop bx
pop ax

ret


;;****************************************************************


ler:                ;; Driver de Teclado do Bin S.O


xor cl, cl


.loop:

mov ah, 0
int 0x16

cmp al, 0x08
je .apagar

cmp al, 0x0D
je .pronto

cmp cl, 0x3F
je .loop

mov ah, 0x0E
int 0x10

stosb

inc cl

jmp .loop


.apagar:          ;; Usa o Driver de Teclado Principal para apagar um caracter


cmp cl, 0
je .loop


dec di
mov byte [di], 0
dec cl

mov ah, 0x0E
mov al, 0x08
int 10h

mov al, ' '
int 10h

mov al, 0x08
int 10h

jmp .loop


.pronto:          ;; Tarefa ou rotina concluida


mov al, 0

stosb

mov ah, 0x0E
mov al, 0x0D
int 0x10

mov al, 0x0A
int 0x10

ret


strcmp:        ;; Compara o que foi inserido com os comandos do aplicativo


.loop:

mov al, [si]
mov bl, [di]
cmp al, bl
jne .diferente

cmp al, 0
je .pronto

inc di
inc si
jmp .loop


.diferente:

clc
ret


.pronto:

stc
ret


;;****************************************************************


atoi:


mov bp,sp
mov bx,[bp+0x2]
push bx
call strlen

add bx,ax
xor di,di
mov al,1
xor cx,cx
atoi_f1:
mov dl,[bx]
cmp dl,'0'
jl    atoi_sair
cmp dl,'9'
jg    atoi_sair
push dx
push ax
sub    dl,0x30
mul dl
add cx,ax
pop ax
mov dl,10
mul dl
pop dx
dec bx
cmp bx,[bp+0x2]
jz atoi_sair
jmp atoi_f1

atoi_sair:
mov ax,cx
ret 2

strlen:
mov bp,sp
mov bx,[bp+0x02]
xor di,di

strlen_w1:
mov dl,[bx+di]
inc di
cmp dl,'$'
jne strlen_w1
dec di
dec di
mov ax,di
ret 2


;;****************************************************************


aguardartecla:

mov ax, 0
int 16h

ret


;;****************************************************************


fim:         ;; Fim do aplicativo


jmp 0x1000:0 ;; Fim do aplicativo (Obrigatório)


;; Variaveis e constantes deverão ser declaradas abaixo.


SIS db 'Bin S.O', 0
VERSAO db 'Versao deste aplicativo: Versao aqui.',0
boasvindas db 'Seja Bem Vindo a este aplicativo de testes do Bin S.O',0
tecla db "", 0x0D, 0x0A
      db "Pressione ENTER para sair deste aplicativo.",0x0D, 0x0A, 0

;; %include 'lib/video.s'


;; Fim
