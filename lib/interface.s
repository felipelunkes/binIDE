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
;;                                                                  *
;;         Esta biblioteca contêm softwares de terceiros            *
;;																	*
;;******************************************************************* 
 

%define  branco_verde  00101111b 
%define  branco_preto  00001111b
%define  vermelho_verde  10100100b
%define  branco_vermelho  11001111b
%define  preto_branco  11110000b 
%define branco_marrom 01100000b


;;*******************************************************************

 
 caixadetexto:
	
	
	;; Sintaxe:
	
	;; AX - Texto do topo da tela
    ;; BX - Texto do final da tela
    ;; CX - Cor da tela	
	
	pusha

	push ax				
	push bx
	push cx

	mov dl, 0
	mov dh, 0
	call movercursor

	mov ah, 09h			;; Desenha barra branca no topo
	mov bh, 0
	mov cx, 80
	mov bl, 01110000b
	mov al, ' '
	int 10h

	mov dh, 1
	mov dl, 0
	call movercursor

	mov ah, 09h			;; Desenha a cor selecionada
	mov cx, 1840
	pop bx				;; Obtem a cor escolhida
	mov bh, 0
	mov al, ' '
	int 10h

	mov dh, 24
	mov dl, 0
	call movercursor

	mov ah, 09h			;; Desenha a barra branca no final da tela
	mov bh, 0
	mov cx, 80
	mov bl, 01110000b
	mov al, ' '
	int 10h

	mov dh, 24
	mov dl, 1
	call movercursor
	pop bx				;; Obtêm o que deverá ser escrito no topo
	mov si, bx
	call imprimir

	mov dh, 0
	mov dl, 1
	call movercursor
	pop ax				;; Obtêm o queve ser escrito no fundo
	mov si, ax
	call imprimir

	mov dh, 1			;; Pula para o que deverá ser escrito
	mov dl, 0
	call movercursor

	popa
	ret

 
;;*******************************************************************  
 
 
 movercursor:
	pusha

	mov bh, 0
	mov ah, 2
	int 10h				

	popa
	ret

;;*******************************************************************  


obterpos:
	pusha

	mov bh, 0
	mov ah, 3
	int 10h				

	mov [.tmp], dx
	popa
	mov dx, [.tmp]
	ret


	.tmp dw 0


;;*******************************************************************  


mostrarcursor:
	pusha

	mov ch, 6
	mov cl, 7
	mov ah, 1
	mov al, 3
	int 10h

	popa
	ret



;;*******************************************************************  


escondercursor:
	pusha

	mov ch, 32
	mov ah, 1
	mov al, 3			
	int 10h

	popa
	ret


;;*******************************************************************  


desenharbloco:


	pusha

.mais:
	call movercursor		;; Mover para primeira posição

	mov ah, 09h			;; Cor selecionada
	mov bh, 0
	mov cx, si
	mov al, ' '
	int 10h

	inc dh				; Passa a próxima linha

	mov ax, 0
	mov al, dh			; Obtêm posição Y
	cmp ax, di			
	jne .mais			

	popa
	ret


;;*******************************************************************  


mostrardialogo:


	pusha

	push ax				

	push cx				
	push bx

	call escondercursor


	mov cl, 0			;; Contar o número de itens da lista
	mov si, ax
	
	
.contar:


	lodsb
	cmp al, 0
	je .pronto_contar
	cmp al, ','
	jne .contar
	inc cl
	jmp .contar

	
.pronto_contar:


	inc cl
	mov byte [.numerodeentradas], cl


	mov bl, 01001111b		;; Escreve em vermelho
	mov dl, 20			;; Posição X
	mov dh, 2			;; Posição Y
	mov si, 40			
	mov di, 23			
	call desenharbloco		

	mov dl, 21			
	mov dh, 3
	call movercursor

	pop si				
	call imprimir

	inc dh				
	call movercursor

	pop si
	call imprimir


	pop si				
	mov word [.listar], si


	mov byte [.pular_num], 0		

	mov dl, 25			
	mov dh, 7

	call movercursor

	
.mais_selecionar:
	pusha
	mov bl, 11110000b		
	mov dl, 21
	mov dh, 6
	mov si, 38
	mov di, 22
	call desenharbloco
	popa

	call .desenharbarrapreta

	mov word si, [.listar]
	call .desenharlista

.outratecla:

	call esperar		
	cmp ah, 48h			;; Cima
	je .irpracima
	cmp ah, 50h			;; Baixo
	je .irprabaixo
	cmp al, 13			;; Enter 
	je .opcaoselecionada
	cmp al, 27			;; Esc
	je .escpressionado
	jmp .mais_selecionar		


.irpracima:


	cmp dh, 7			
	jle .pressionado_top

	call .desenharbarrabranca

	mov dl, 25
	call movercursor

	dec dh				
	jmp .mais_selecionar


.irprabaixo:		

		
	cmp dh, 20
	je .pressionado

	mov cx, 0
	mov byte cl, dh

	sub cl, 7
	inc cl
	add byte cl, [.pular_num]

	mov byte al, [.numerodeentradas]
	cmp cl, al
	je .outratecla

	call .desenharbarrabranca

	mov dl, 25
	call movercursor

	inc dh
	jmp .mais_selecionar


.pressionado_top:


	mov byte cl, [.pular_num]	
	cmp cl, 0
	je .outratecla			

	dec byte [.pular_num]		
	jmp .mais_selecionar


.pressionado:		

		
	mov cx, 0
	mov byte cl, dh

	sub cl, 7
	inc cl
	add byte cl, [.pular_num]

	mov byte al, [.numerodeentradas]
	cmp cl, al
	je .outratecla

	inc byte [.pular_num]		
	jmp .mais_selecionar



.opcaoselecionada:


	call mostrarcursor

	sub dh, 7

	mov ax, 0
	mov al, dh

	inc al				
	
	add byte al, [.pular_num]	

	mov word [.tmp], ax		

	popa

	mov word ax, [.tmp]
	clc				
	ret



.escpressionado:


	call mostrarcursor
	popa
	stc				;; Definir carry para esc
	ret



.desenharlista:


	pusha

	mov dl, 23			
	mov dh, 7
	call movercursor


	mov cx, 0			
	mov byte cl, [.pular_num]

	
.pular_loop:


	cmp cx, 0
	je .pular_loop_terminado
	
	
.mais_lodsb:


	lodsb
	cmp al, ','
	jne .mais_lodsb
	dec cx
	jmp .pular_loop


.pular_loop_terminado:


	mov bx, 0			


.mais:


	lodsb				

	cmp al, 0			
	je .pronto_list

	cmp al, ','			;; nova opção. Separada por ","
	je .novalinha

	mov ah, 0Eh
	int 10h
	jmp .mais

.novalinha:


	mov dl, 23			
	inc dh				
	call movercursor

	inc bx				
	cmp bx, 14			
	jl .mais

.pronto_list:


	popa
	call movercursor

	ret



.desenharbarrapreta:


	pusha

	mov dl, 22
	call movercursor

	mov ah, 09h			
	mov bh, 0
	mov cx, 36
	mov bl, 00001111b		
	mov al, ' '
	int 10h

	popa
	ret



.desenharbarrabranca:


	pusha

	mov dl, 22
	call movercursor

	mov ah, 09h			
	mov bh, 0
	mov cx, 36
	mov bl, 11110000b		
	mov al, ' '
	int 10h

	popa
	ret


	.tmp			dw 0
	.numerodeentradas		db 0
	.pular_num		db 0
	.listar		dw 0



;;*******************************************************************  	


esperar:


	pusha

	mov ax, 0
	mov ah, 10h			
	int 16h

	mov [.tmp_esperar], ax		

	popa				
	mov ax, [.tmp_esperar]
	ret


	.tmp_esperar	dw 0

	
	
;;*******************************************************************  

	imprimir:
	
		pusha

	mov ah, 0Eh			

.repeat:
	lodsb				
	cmp al, 0
	je .done			

	int 10h				
	jmp .repeat			

.done:
	popa
	ret


;;*******************************************************************  

	
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

    
 