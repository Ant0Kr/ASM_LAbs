.model small
.stack 100h
.data
    input_line db "Please!Input line!",10,13,'$'
    start_line db "Start line:",10,13,'$' 
    result_line db "Result line:",10,13,'$'
    input_word db "Please!Input word!",10,13,'$'
    error_mes db "Error!Repeat input!",10,13,'$'
    str db 202 dup(?)               ;исходная строка
    transp_str db 13,10,'$'         ;строка переноса
    delete_word db 202 dup(?)       ;слово для удаления
    
.code
start:
      mov ax,@data                  ; в ds адрес сегм. данных
      mov ds,ax
      
      lea dx,input_line             ;адрес начала строки input_line в dx
      mov ah,09h                    ;вывод строки
      int 21h
      
      mov str[0],200                ;0 байт размер строки
          
      lea dx,str                    ;ввод строки 
      mov ah,0Ah
      int 21h
                                    ;в 1 байт занесется реальный размер строки
      xor bx,bx                     ;в конец ставим $
      mov bl,str[1]
      add bl,2
      mov str[bx],'$'
       
      lea dx,transp_str             ;вывод строки переноса
      mov ah,09h
      int 21h
       
      lea dx,start_line             ;информационная строка
      mov ah,09h                    
      int 21h
      
      lea dx,str[2]                 ;вывод введенной строки
      mov ah,09h
      int 21h 
     
      mov delete_word[0],200
      
      lea dx,transp_str             ;вывод строки переноса
      mov ah,09h
      int 21h
      
      lea dx,input_word             ;адрес начала строки input_line в dx
      mov ah,09h                    ;вывод строки
      int 21h
      
word_input:                         ;ввод удаляемого слова
       
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
      
check_space:                        ;метка проверки пробелов
      cmp delete_word[si+1],' '
      je error
      cmp delete_word[si+1],'$'
      je xor_si
      inc si
      jmp check_space 
      
error:
      lea dx,transp_str             ;вывод строки переноса
      mov ah,09h
      int 21h
      
      lea dx,error_mes             ;вывод строки ошибки
      mov ah,09h                   
      int 21h
      jmp word_input
           
xor_si:
      xor si,si                     ;обнуляем индексный регистр
      mov si,1
      jmp space
      
space:                              ;метка пропуска пробелов
      cmp str[si+1],'$'             ;если конец строки
      je end_line
      cmp str[si+1],' '             ;если нашли слово
      jne get_push
      inc si
      jmp space
      
      
get_push:                           ;в стек заносим индекс перед словом и
      xor bx,bx
      mov bx,2                      ;индекс перед словом
      push si                       ;и индекс начала слова 
      add si,1
      push si
      sub si,1
      jmp compare_word
        
           
compare_word:                       ;метка сравнение слов строки и заданого
      cmp delete_word[bx],'$'          ;если сравниваемое конец
      je last_compare               ;то переход по следующей метке сравнения
      mov dl, str[si+1]             ;иначе
      mov dh,delete_word[bx]           ;сравниваем символы слов
      cmp dl,dh   
      jne miss_characters           ;если символы не равны то пропускаем всю информацию до следующего слова
      inc si
      inc bx 
      jmp compare_word
             
             
miss_characters:                    ;метка пропуска непробельной информации
      cmp str[si+1],'$'             ;если конец строки то завершаем программу
      je end_line
      cmp str[si+1],' '             ;если в строке после слова идут пробелы
      je space                      ;то пропускаем их
      inc si                        
      jmp miss_characters           ;иначе просто пропускаем кусок слова        
                           
                           
last_compare:                       ;второй уровень сравнения
      cmp str[si+1],' '             ;если в строке после найденного слова пробел
      je get_pop                    ;или после найденного конец строки
      cmp str[si+1],'$'             
      je get_pop                    ;то вытягиваем из стека индекс начала слова
      jmp miss_characters           ;иначе пропускаем слово в строке, которое 
                                    ;не закончилось
                                    
get_pop:                            ;забираем из стека индекс начала удаляемого слова
      pop si                        ;индекс начала слова в строке
      add bx,si
      sub bx,2                      ;индекс конца слова в строке
      jmp transp   
   
        
transp:                             ;перетяжка куска слова
      cmp str[bx],'$'               ;если конец строки
      je set_end                    ;переход на метку конца строки
      mov dl, str[bx]               ;иначе перетягиваем 
      mov str[si], dl
      inc si
      inc bx
      jmp transp
    
      
set_end:                            ;установление конца('$') 
      mov dl, str[bx]               ;по индексу si ставим '$'
      mov str[si], dl
      pop si                        ;если мы удалили слово из середины и перетянули
      cmp str[si],'$'               ;на позицию удаленного новое слово
      jne space                     ;начиаем проверку снова
      jmp end_line      

      
end_line:
      
      lea dx,transp_str             ;вывод строки переноса
      mov ah,09h
      int 21h
      
      lea dx,result_line            ;информационная строка  
      mov ah,09h
      int 21h
      
      lea dx,str[2]                 ;вывод введенной строки
      mov ah,09h
      int 21h           
      
      mov ax,4C00h                  ;завершение программы
      int 21h
    
end start