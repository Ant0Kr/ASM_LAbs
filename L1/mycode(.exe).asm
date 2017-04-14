.model small
.stack 100h
.data 
      mes db "Anton Karachun",10,13,'$'
.code
start:
      mov ax,@data
      mov ds,ax
      mov dx,offset mes
      mov ah,9
      int 21h
      mov ah,4ch
      int 21h
end start