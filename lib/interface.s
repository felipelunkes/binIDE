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
	call escrever

	mov dh, 0
	mov dl, 1
	call movercursor
	pop ax				;; Obtêm o queve ser escrito no fundo
	mov si, ax
	call escrever

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
	call escrever

	inc dh				
	call movercursor

	pop si
	call escrever


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


caixadialogo:


	pusha

	mov [.tmp], dx

	call escondercursor

	mov dh, 9			
	mov dl, 19

	
.caixavermelha:	

		
	call movercursor

	pusha
	mov ah, 09h
	mov bh, 0
	mov cx, 42
	mov bl, 01001111b	
	mov al, ' '
	int 10h
	popa

	inc dh
	cmp dh, 16
	je .boxpronto
	jmp .caixavermelha


.boxpronto: 


	cmp ax, 0			
	je .naoeaprimeira
	mov dl, 20
	mov dh, 10
	call movercursor

	mov si, ax			
	call escrever

.naoeaprimeira:             ;; Primeira String

                      
	cmp bx, 0
	je .naoeasegunda
	mov dl, 20
	mov dh, 11
	call movercursor

	mov si, bx			
	call escrever

	
.naoeasegunda:             ;; Segunda String

         
	cmp cx, 0
	je .naoeaterceira
	mov dl, 20
	mov dh, 12
	call movercursor

	mov si, cx			
	call escrever

	
.naoeaterceira:             ;; Terceira String


	mov dx, [.tmp]
	cmp dx, 0
	je .umbotao
	cmp dx, 1
	je .botao_dois


.umbotao:


	mov bl, 11110000b		
	mov dh, 14
	mov dl, 35
	mov si, 8
	mov di, 15
	call desenharbloco

	mov dl, 38			 ;; Botão OK, criado no meio da tela
	mov dh, 14
	call movercursor
	mov si, .botao_ok
	call escrever

	jmp .umbotao_esperar


.botao_dois:


	mov bl, 11110000b		
	mov dh, 14
	mov dl, 27
	mov si, 8
	mov di, 15
	call desenharbloco

	mov dl, 30			
	mov dh, 14
	call movercursor
	mov si, .botao_ok
	call escrever

	mov dl, 44			     ;; Botão cancelarar
	mov dh, 14
	call movercursor
	mov si, .botao_cancelarar
	call escrever

	mov cx, 0			
	jmp .botao_dois_esperar



.umbotao_esperar:


	call esperar
	cmp al, 13			
	jne .umbotao_esperar

	call mostrarcursor

	popa
	ret


.botao_dois_esperar:


	call esperar

	cmp ah, 75			
	jne .esqueda

	mov bl, 11110000b	
	mov dh, 14
	mov dl, 27
	mov si, 8
	mov di, 15
	call desenharbloco

	mov dl, 30			
	mov dh, 14
	call movercursor
	mov si, .botao_ok
	call escrever

	mov bl, 01001111b		
	mov dh, 14
	mov dl, 42
	mov si, 9
	mov di, 15
	call desenharbloco

	mov dl, 44			
	mov dh, 14
	call movercursor
	mov si, .botao_cancelarar
	call escrever

	mov cx, 0			
	jmp .botao_dois_esperar


.esqueda:


	cmp ah, 77			
	jne .nodireita


	mov bl, 01001111b		
	mov dh, 14
	mov dl, 27
	mov si, 8
	mov di, 15
	call desenharbloco

	mov dl, 30			
	mov dh, 14
	call movercursor
	mov si, .botao_ok
	call escrever

	mov bl, 11110000b		
	mov dh, 14
	mov dl, 43
	mov si, 8
	mov di, 15
	call desenharbloco

	mov dl, 44			
	mov dh, 14
	call movercursor
	mov si, .botao_cancelarar
	call escrever

	mov cx, 1			
	jmp .botao_dois_esperar


.nodireita:


	cmp al, 13			
	jne .botao_dois_esperar

	call mostrarcursor

	mov [.tmp], cx			
	popa
	mov ax, [.tmp]

	ret


	.botao_ok	db 'Confirmar', 0
	.botao_cancelarar	db 'cancelarar', 0
	.ok_botao_noselecionar	db '   Confirmar   ', 0
	.cancelar_botao_noselecionar	db '   cancelarar   ', 0

	.tmp dw 0


;;*******************************************************************  


imprimirespaco:


	pusha

	mov ah, 0Eh			
	mov al, 20h			
	int 10h

	popa
	ret


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

	
obterstring:                ;; Driver de Teclado do Bin S.O


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


