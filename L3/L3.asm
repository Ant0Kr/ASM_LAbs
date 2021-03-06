number_syst equ 10       
max_number equ 32767
.model
.stack 100h
.data
      mas dw 10 dup(?)
      num db 9 dup(?)
      res_str db 212 dup(?)
      max_index db 5 dup(?)
      max_num db 9 dup(?)
       
      input_line db "Please!Input number!",10,13,'$' 
      error_mes db "Error!Repeat input!",10,13,'$'
      start_line db "Start line:",10,13,'$' 
      num_mes db "Number:",'$'
      count_mes db "Counter:",'$'
      output_mas db "Massiv:",'$'
      transp db 10,13,'$'
      
      flag dw 0
      

cout MACRO input_line
      lea dx,input_line             ;����� ������ ������ input_line � dx
      mov ah,09h                    ;����� ������
      int 21h
endm

cin MACRO num                        
      mov num[0],7
      lea dx,num
      mov ah,0Ah
      int 21h
      
      xor bx,bx
      mov bl,num[1]
      add bl,2
      mov num[bx],'$'
endm

.code

start:
      mov ax,@data
      mov ds,ax
      
      lea si,mas 
      mov [si],8                    ;� 0 ������ ������ ������ �������     
         
mas_input:                          
      call input                    ;��������� ������������� �������
      jmp mas_input                 ;���� �������, ���� �� ��������� jmp ������ ���������

end_input:                          ;����� ����� ����� �������
      
      mov cx,mas[2]                 ;� cx ���-�� �������� ����� = ���-�� ��������� �������
      push cx                       ;��������� � �����
      xor di,di                     ;������� ���������� ��������
      lea si,mas                    ;������ �������� � ������� ����������
      add si,4
      push si                       ;��������� � �����
       
      
pre_cycle:                          
      pop si                        ;����� ������-������ ��� ���������� �����(���� �������� ��������� ���������)
      add si,2                      ;��������� ������ ���������� �������� ��� ���������
      
      pop cx                        ;������� ��������� �� ����(���� ����� �� ����� ������� � ��������� ��� ��������)
      cmp cx,0
      je end_prog
      dec cx                        ;����� ��������� ���-�� �������� ������������ �����
      push cx                       ;��������� �������� � �����
      inc cx                        ;����������� cx �� 1 ��� �������� �����
      push si                       ;��������� ������ ����. ��������
      sub si,2                      ;� ������ ������ ������� �� ����������
      mov dx,[si]                   ;� dx �������� �������� � ������� ����������
      xor bx,bx                     ;� bx ����� ��������� ���-�� ���������� ��������
            
cycle:
      cmp cx,0                      ;���� cx ���� �� �������
      je after_cycle
      cmp dx,[si]                   ;���� ����� ����� �� �������
      je increm                     ;�� �������������� �������
      add si,2                      ;������� � ���� �����
      dec cx                        ;���������� �������� ��������
      jmp cycle
            
after_cycle:
      cmp bx,di                     ;���������� ���-�� ���������� � ������������
      jg set_max_value              ;���� ��� ������
      jmp pre_cycle
      
set_max_value:                      ;���������� ������������ ��������
      mov di,bx                     ;����������
      mov ax,dx                     ;� ��� �������
      jmp pre_cycle
      
increm:
      inc bx                        ;����������� ������� ����������
      dec cx                        ;��������� ������� ��������
      add si,2                      ;��������� �� ���� �������
      jmp cycle          

end_prog:              
      call value_output
      call index_output
      call mas_output 
         
      cout transp
      cout output_mas
      cout res_str[2]
      cout transp
      cout num_mes
      cout max_num[2]
      cout transp
      cout count_mes
      cout max_index[2]
      
      mov ax,4C00h
      int 21h
      
mas_output PROC
 
      lea di,mas                    ;����� �������� �����
      add di,2                      
      lea si,res_str                ;����� �������� ����� ������
      xor cx,cx                     ;����� ��������
      mov [si],210                  
      inc si
      mov [si],0
      inc si
      mov bx,10
      

pre_div:
      push cx
      xor dx,dx 
      xor cx,cx
      add di,2                      ;���������� di �� ��������� �������
      mov ax,[di]                   ;div �������� � ax
      cmp ax, max_number
      jbe divv_
      dec ax                        ;���� ����� ����� �� ����������� ���
      not ax
      mov [si], '-'                 ;������� �����
      inc res_str[1]                ;���-�� ��������� ������ �����������
      inc si   
      
divv_:
      div bx                        ;ax/10
      inc cx
      inc res_str[1]
      push dx                       ;����� � ����
      xor dx,dx
      cmp ax,0                      ;����� �� ���� � �������
      je write_cycl
      jmp divv_ 
      
write_cycl:
      pop dx                        ;������� �� �����
      add dx,30h                    ;�������� ���� ���
      mov [si],dl                   ;�������� � ������� ������
      inc si
      loop write_cycl
      
      pop cx                        ;������� �� ����� ������� ���������� �����
      inc cx
      cmp cx,mas[2]                 ;���������� ��� � ���-��� ����� � �������
      je set_ret
      
      mov [si],' '                  ;����� ������� ����� ������ ������
      inc si 
      jmp pre_div
      
set_ret:                            ;���� ����� ������ ���, �� � ����� ������ ������ '$'
      mov [si],'$'
      ret   
                     
mas_output endp 





value_output PROC
      
      lea si,max_num
      mov [si],7
      xor dx,dx 
      xor cx,cx
      inc si
      mov [si],0
      inc si
      mov bx,10
      cmp ax, max_number
      jbe divis_
      dec ax
      not ax
      mov [si], '-'
      inc si
      
divis_:
      div bx
      inc cx
      inc max_num[1]
      push dx 
      xor dx,dx
      cmp ax,0
      je write_cyc
      jmp divis_ 
      
write_cyc:
      pop dx
      add dx,30h
      mov [si],dl
      inc si
      loop write_cyc
      
      mov [si],'$'
      
      ret  
      
value_output endp      

 
 
 
 
 
index_output PROC
      lea si,max_index
      mov [si],3
      mov ax,di
      xor dx,dx 
      xor cx,cx
      inc si
      mov [si],0
      inc si
      mov bx,10
           
div_:
      div bx
      inc cx
      inc max_index[1]
      push dx 
      xor dx,dx
      cmp ax,0
      je write_cycle
      jmp div_ 
      
write_cycle:
      pop dx
      add dx,30h
      mov [si],dl
      inc si
      loop write_cycle
      
      mov [si],'$'
      
      ret  
index_output endp




           
input PROC                          ;��������� ����� �������
      xor si,si                     ;���������� �� �������
      add si,4                      ;������ �� ������, ��� ���������� �����
      add si,mas[2]                 ;��������� ���-�� ��������� ���������*2(�.� ��� �����)
      add si,mas[2]                 ;����� �� ������� ������ ��� ���� � ��� ��
      push si                       ; � ����� ������� ������� ��� ����� �����(��������� �� � ����)
      cout input_line
      mov flag,0                    ;�������� ���� �������������� �����
      cin num                       ;���� �����
      xor si,si
      mov si,2
   
      cmp num[si],'-'               ;��������� ���� �����
      jne check_input               ;���� �� �����
      mov flag,1                    ;���� ����� �� ���� � 1
      inc si                        ;���������� '-'
      jmp check_input
      
      
check_input:
      cmp num[si],'$'               
      je pre_transparent_num
      cmp num[si],'0'
      jl error
      cmp num[si],'9'
      jg error
      inc si
      jmp check_input 
            
pre_transparent_num:
     xor si,si
     xor cx,cx
     xor bx,bx
     xor ax,ax
     mov cl,num[1]                  ;������������� � ������� ����� �����,��� �����
     sub cx,flag                    ;�������� ����(���� ����� �����, �� ��������� �����)
     mov si,2                       
     add si,flag                    ;���������� ���� '-' ���� �� ����
     mov bl,number_syst             ;� bl ��������� ������� ���������
     
     
transparent_num:
     
     mul bx                         ;�������� �� �� 10
     mov dl,num[si]
     sub dl,30h                     ;�������� ����� � ������ ����
     add ax,dx                      ;��������� � �����������
     cmp ax,max_number              ;���� ������������
     ja error
     inc si
     
     loop transparent_num
     
     cmp flag,0                     ;���� ���� �� ����, �� ����������� ����� � ��������� 1(��� ���)
     je save_num
     not ax
     inc ax
     
save_num:                               
     pop si                         ;�������� ������ �������� ��� ����������
     inc mas[2]                     ;����������� ������� ��������� ��������� �������
     mov mas[si],ax                 ;����������
     xor dx,dx
     mov dx,mas[0]                  ;���������� ��� ��������� � ����. ���� ���-��� ��� �����
     cmp dx,mas[2]
     jle end_input
     cout transp
     ret
                 
error:
      cout transp
      cout error_mes
      jmp mas_input
       
input endp          
end start