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


binparadecimal:

;; AL = entrada
;; AX = Saída

	pusha

	mov bl, al			

	and ax, 0Fh			
	mov cx, ax			

	shr bl, 4		
	mov al, 10
	mul bl				

	add ax, cx			
	mov [.tmp], ax

	popa
	mov ax, [.tmp]			
	ret


	.tmp	dw 0
	
	
	
;;****************************************************************

	
	pausar:
	
	;; AX: Tempo para pausar a execução do programa
	
	
	pusha
	cmp ax, 0
	je .passou			

	mov cx, 0
	mov [.var_contar], cx		

	mov bx, ax
	mov ax, 0
	mov al, 2			
	mul bx				
	mov [.delayoriginal], ax	

	mov ah, 0
	int 1Ah				

	mov [.anterior], dx	

.checarloop:
	mov ah,0
	int 1Ah				

	cmp [.anterior], dx	

	jne .sincronizado			
	jmp .checarloop			

.passou:
	popa
	ret

.sincronizado:
	mov ax, [.var_contar]		
	inc ax
	mov [.var_contar], ax

	cmp ax, [.delayoriginal]
	jge .passou			

	mov [.anterior], dx	

	jmp .checarloop			


	.delayoriginal	dw	0
	.var_contar		dw	0
	.anterior	dw	0

