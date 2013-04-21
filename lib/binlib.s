
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

nucleo equ 0x1000:0
ver db "1,0",0
API db '1.0',0
COPYRIGHT db "Copyright (C) 2013 Felipe Miguel Nery Lunkes",0


;;*******************************************************************


escrevercaractere:            ;; Driver para imprimir caracteres na tela 
  
    lodsb        
 
   or al, al  
   jz .pronto   
 
   mov ah, 0x0E
   int 0x10      
 
   jmp escrevercaractere

 
 .pronto:
   ret
   
   
;;*******************************************************************   


parahexa:
	pusha
	mov bp,sp
	mov dx, [bp+20]
	push dx	
	call escrevercaractere
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
	call escrevercaractere
	mov sp,bp
	popa
	ret
	
	
;;*******************************************************************


emitirsom:       ;; Mova para ax o tom a ser emitido pelo sistema.

    pusha

	mov cx, ax	 ;; Som a ser emitido		

	mov al, 182  ;; Dado a ser enviado
	out 43h, al  
	mov ax, cx			
	out 42h, al
	mov al, ah
	out 42h, al

	in al, 61h			
	or al, 03h
	out 61h, al

	popa
	
	ret
	

;;*******************************************************************
	
	
desligarsom:      ;; Desliga o som do Computador

	
	pusha

	in al, 61h
	and al, 0FCh
	out 61h, al

	popa
	
	ret	
	

;;*******************************************************************	
	

esperartecla:


    mov ax, 0
    int 16h
    
    ret
    
    
;;*******************************************************************  


retornarapi:

mov si, versaoapi
call escrevercaractere

ret


;;*******************************************************************  



	
hex db "0x0000",10,13,0
hexc db "0123456789ABCDEF"
testt db 'Ola!',10,13,0
SISTEMA db 'Bin S.O',0
APPAPI db "1.0",0
versaoapi db '1.0',0
       
