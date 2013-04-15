
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
	
