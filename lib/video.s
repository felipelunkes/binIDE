
;;*******************************************************************
;;                                                                  *
;;           														*
;;   Biblioteca de execução para a construção de aplicativos para   *
;;																	*
;;                 o Sistema Operacional Bin S.O     				*
;;																	*
;;																	*
;;   Esta biblioteca implementa rotinas padrão compatíveis com o	*
;;																	*
;;                             sistema.								*
;;																	*
;;												 					*
;;																	*
;;         Copyright (C) 2013 Felipe Miguel Nery Lunkes				*
;;																	*
;;																	*
;;*******************************************************************

   
;;*******************************************************************   


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

;;*******************************************************************
