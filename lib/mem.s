
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


parahexa:


	pusha
	mov bp,sp
	mov dx, [bp+20]
	push dx	
	call escrever
	mov dx,[bp+18]

	mov cx,4
	mov si,hexc
	mov di,hex+2
	
	guardar:
	
	
	rol dx,4
	mov bx,15
	and bx,dx
	mov al, [si+bx]
	stosb
	loop guardar
	push hex
	call escrever
	mov sp,bp
	popa
	ret
	
	
;;*******************************************************************


	
hex db "0x0000",10,13,0
hexc db "0123456789ABCDEF"
testt db 'Ola!',10,13,0
SISTEMA db 'Bin S.O',0
APPAPI db "1.0",0
versaoapi db '1.0',0
       
