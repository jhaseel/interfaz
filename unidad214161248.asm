SYS_EXIT equ 1
SYS_READ equ 3
SYS_WRITE equ 4
STDIN equ 0
STDOUT equ 1

segment .data
	saludo db "La conjetura de Collatz", 0xA,0xD
	tamaniosaludo equ $ - saludo
	texto db "numero par", 0xA,0xD
	tamaniotexto equ $ - texto

	texto2 db "numero impar", 0xA,0xD
	tamaniotexto2 equ $ - texto2

	espacio db "  "
	longitudespacio equ $ - espacio

	letrero db "lasuma es: "
	longitudletrero equ $ - letrero

	msg4 db "<--",0xA,0xD
	len4 equ $ - msg4

segment .bss
	num1 resb 2
	num2 resb 2
	res resb 1


section  .text
	global _start  ;must be declared for using gcc
_start:  ;tell linker entry point

	mov eax, SYS_WRITE
	mov ebx, STDOUT
	mov ecx, saludo
	mov edx, tamaniosaludo
	int 0x80

	;asigna valor a usar
		mov bx, 6
		mov [num1], bx

		;suma 48
		mov ax,48
		add [num1],ax
		;imprime
		mov eax, 4
		mov ebx, 1
		mov ecx, num1
		mov edx, 5
		int 80h
		;resta 48
		mov ax,48
		sub [num1],ax
		;imprime espacio
		mov eax, SYS_WRITE
		mov ebx, STDOUT
		mov ecx, espacio
		mov edx, longitudespacio
		int 0x80


	ciclo:
	;revisa que num1 no sea 1, si lo es termina
	mov ax,[num1]
	cmp ax,1
	je salida

;si no es 1, divide entre 2 para saber si es par, con respecto al residuo
	mov ax,[num1]
	mov bx,2
	mov dx,0
	div bx
;compara el residio = 0
	cmp dx,0
	je par
	jmp impar

	par:
	;divide entre 2
	mov ax,[num1]
	mov bx,2
	mov dx,0
	div bx
	mov [num1],ax

;suma 48
	mov ax,48
	add [num1],ax
	;imprime numero
	mov eax, 4
	mov ebx, 1
	mov ecx, num1
	mov edx, 5
	int 80h

 ;imprime espacio  jeje
	mov eax, SYS_WRITE
	mov ebx, STDOUT
	mov ecx, espacio
	mov edx, longitudespacio
	int 0x80

 ;resta 48 para convertir a decimal y
	mov ax,48
	sub [num1],ax
	jmp ciclo

	impar:

;multiplica pr x
	mov ax,[num1]
	mov bx,3
	mul bx
	;suma 1
	mov bx,1
	add ax,bx
	mov [num1],ax
;suma 48 para ascii
	mov ax,48
	add [num1],ax
;imprime num
	mov eax, 4
	mov ebx, 1
	mov ecx, num1
	mov edx, 5
	int 80h
;imprime espacio
	mov eax, SYS_WRITE
	mov ebx, STDOUT
	mov ecx, espacio
	mov edx, longitudespacio
	int 0x80
; resta 48 y se mueve a cico con el nuevo valor
	mov ax,48
	sub [num1],ax
	jmp ciclo


salida:
	mov eax, SYS_EXIT
	xor ebx, ebx  ;EBX=0 INDICA EL CODIGO DE RETORNO (0=SIN ERRORES)
	int 0x80
