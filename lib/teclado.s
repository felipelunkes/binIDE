
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

;;****************************************************************
