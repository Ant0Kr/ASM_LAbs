.model small
.stack 100h
.data
    input_line db "Please!Input line!",10,13,'$'
    start_line db "Start line:",10,13,'$' 
    result_line db "Result line:",10,13,'$'
    input_word db "Please!Input word!",10,13,'$'
    error_mes db "Error!Repeat input!",10,13,'$'
    str db 202 dup(?)               ;�������� ������
    transp_str db 13,10,'$'         ;������ ��������
    delete_word db 202 dup(?)       ;����� ��� ��������
    
.code
start:
      mov ax,@data                  ; � ds ����� ����. ������
      mov ds,ax
      
      lea dx,input_line             ;����� ������ ������ input_line � dx
      mov ah,09h                    ;����� ������
      int 21h
      
      mov str[0],200                ;0 ���� ������ ������
          
      lea dx,str                    ;���� ������ 
      mov ah,0Ah
      int 21h
                                    ;� 1 ���� ��������� �������� ������ ������
      xor bx,bx                     ;� ����� ������ $
      mov bl,str[1]
      add bl,2
      mov str[bx],'$'
       
      lea dx,transp_str             ;����� ������ ��������
      mov ah,09h
      int 21h
       
      lea dx,start_line             ;�������������� ������
      mov ah,09h                    
      int 21h
      
      lea dx,str[2]                 ;����� ��������� ������
      mov ah,09h
      int 21h 
     
      mov delete_word[0],200
      
      lea dx,transp_str             ;����� ������ ��������
      mov ah,09h
      int 21h
      
      lea dx,input_word             ;����� ������ ������ input_line � dx
      mov ah,09h                    ;����� ������
      int 21h
      
word_input:                         ;���� ���������� �����
       
      lea dx,delete_word
      mov ah,0Ah
      int 21h
      
      xor bx,bx
      mov bl,delete_word[1]
      add bl,2
      mov delete_word[bx],'$'
      xor si,si
      mov si,1
      jmp check_space
      
check_space:                        ;����� �������� ��������
      cmp delete_word[si+1],' '
      je error
      cmp delete_word[si+1],'$'
      je xor_si
      inc si
      jmp check_space 
      
error:
      lea dx,transp_str             ;����� ������ ��������
      mov ah,09h
      int 21h
      
      lea dx,error_mes             ;����� ������ ������
      mov ah,09h                   
      int 21h
      jmp word_input
           
xor_si:
      xor si,si                     ;�������� ��������� �������
      mov si,1
      jmp space
      
space:                              ;����� �������� ��������
      cmp str[si+1],'$'             ;���� ����� ������
      je end_line
      cmp str[si+1],' '             ;���� ����� �����
      jne get_push
      inc si
      jmp space
      
      
get_push:                           ;� ���� ������� ������ ����� ������ �
      xor bx,bx
      mov bx,2                      ;������ ����� ������
      push si                       ;� ������ ������ ����� 
      add si,1
      push si
      sub si,1
      jmp compare_word
        
           
compare_word:                       ;����� ��������� ���� ������ � ��������
      cmp delete_word[bx],'$'          ;���� ������������ �����
      je last_compare               ;�� ������� �� ��������� ����� ���������
      mov dl, str[si+1]             ;�����
      mov dh,delete_word[bx]           ;���������� ������� ����
      cmp dl,dh   
      jne miss_characters           ;���� ������� �� ����� �� ���������� ��� ���������� �� ���������� �����
      inc si
      inc bx 
      jmp compare_word
             
             
miss_characters:                    ;����� �������� ������������ ����������
      cmp str[si+1],'$'             ;���� ����� ������ �� ��������� ���������
      je end_line
      cmp str[si+1],' '             ;���� � ������ ����� ����� ���� �������
      je space                      ;�� ���������� ��
      inc si                        
      jmp miss_characters           ;����� ������ ���������� ����� �����        
                           
                           
last_compare:                       ;������ ������� ���������
      cmp str[si+1],' '             ;���� � ������ ����� ���������� ����� ������
      je get_pop                    ;��� ����� ���������� ����� ������
      cmp str[si+1],'$'             
      je get_pop                    ;�� ���������� �� ����� ������ ������ �����
      jmp miss_characters           ;����� ���������� ����� � ������, ������� 
                                    ;�� �����������
                                    
get_pop:                            ;�������� �� ����� ������ ������ ���������� �����
      pop si                        ;������ ������ ����� � ������
      add bx,si
      sub bx,2                      ;������ ����� ����� � ������
      jmp transp   
   
        
transp:                             ;��������� ����� �����
      cmp str[bx],'$'               ;���� ����� ������
      je set_end                    ;������� �� ����� ����� ������
      mov dl, str[bx]               ;����� ������������ 
      mov str[si], dl
      inc si
      inc bx
      jmp transp
    
      
set_end:                            ;������������ �����('$') 
      mov dl, str[bx]               ;�� ������� si ������ '$'
      mov str[si], dl
      pop si                        ;���� �� ������� ����� �� �������� � ����������
      cmp str[si],'$'               ;�� ������� ���������� ����� �����
      jne space                     ;������� �������� �����
      jmp end_line      

      
end_line:
      
      lea dx,transp_str             ;����� ������ ��������
      mov ah,09h
      int 21h
      
      lea dx,result_line            ;�������������� ������  
      mov ah,09h
      int 21h
      
      lea dx,str[2]                 ;����� ��������� ������
      mov ah,09h
      int 21h           
      
      mov ax,4C00h                  ;���������� ���������
      int 21h
    
end start