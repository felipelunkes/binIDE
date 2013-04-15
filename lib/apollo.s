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

;; Biblioteca de definicoes para aplicativos baseados no Bin S.O 0.1.1 Apollo apenas. Nao utilize para Bin S.O 0.1.0


[bits 16]
[org 0]



apollo:


mov ax, cs
mov ds, ax
mov es, ax

mov ax, 0 ;; Debug Indisponível
mov [0x8FFE], ax

mov ax, 1
mov [0x8FFF], ax

	
API db '1.0',0
BINVER db '0.1.1',0	
RC db 'RC1',0
%define BRC 1