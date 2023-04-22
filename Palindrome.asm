;   Detect palindromes
;   Jocelyn Martinez, April 2022

.586
.MODEL FLAT

INCLUDE io.h            ; header file for input/output

.STACK 4096

.DATA

prompt        BYTE    "Enter phrase", 0
string        BYTE    40 DUP (0), 0
notPalindrome BYTE    "This is not a palindrome", 0
palindrome    BYTE    "This is a palindrome", 0
length_x      DWORD   ?                     ; Reminder: the word "length" cannot be used in Assembly

.CODE

_MainProc PROC

;  Read the string from the user

        input   prompt, string, 40   

;  Find the length of the string, and squish out bad characters.

        mov     eax, 0                      ; Number of characters in the string, index. Characters in the input string.
        mov     ecx, 0                      ; String with bad characters,

      start_loop:                           ; Count the length of array
       lea      ebx, string
       mov      dl, [ebx+eax]
       cmp      dl, 0
       je       end_loop;                   ; If it's equal to 0, the last element is found.
       mov      edx, [ebx+eax]
       cmp      dl, 'A'               ; 'A'
       jl       next_char
       cmp      dl, 'Z'               ; 'Z'
       jg       small_char
            add      dl, 32                      ; Convert to lower case
            mov      [ecx+ebx], dl               ; Squish out any intervening bad chars
            inc      ecx                         ; Ready for next char
            jmp      next_char
      small_char:
         mov      edx, [ebx+eax]
         cmp      dl, 'a'              ; 'a'
         jl       next_char
         cmp      dl, 'z'              ; 'z'
         jg       next_char
         mov      [ecx+ebx], dl               ; Squish out any intervening bad chars
         inc      ecx                         ; Ready for next char
      next_char:
         inc    eax
         jmp    start_loop
       end_loop:
       mov      length_x, ecx



;  Now we have the length of the string.  Let's analyze the front 
;  of the string and the end of the string.
;  To find out if it's a palindrome or not

;;;;;;;;;; COMPARE THE FRONT TO THE END
        mov     edx, 0
        lea     eax, string
        mov     ebx, 0              ; First letter of the string
        mov     ecx, length_x       ; Last letter of the string
        dec     ecx 
      COMPARELOOP:
        mov     dl, [ebx+eax]
        cmp     dl, [ecx+eax]
        jne     REPORTNO            ; If the letters are not equal, it is not a palindrome
        inc     ebx
        dec     ecx
        cmp     bl, cl              ; Check if they've crossed
        jg      REPORTYES           ; It's a palindrome because it did not find an error, finished looking at the string.
        jmp     COMPARELOOP

;;;;;;;;;; JMP TO YES if it is a palindrome
;;;;;;;;;; JMP TO NO if it is not a palindrome

;  Report YES!
REPORTYES:
        output  prompt, palindrome
		jmp     DONE
		
;  Report NO!
REPORTNO:     
        output  prompt, notPalindrome

DONE:
        mov     eax, 0  ; exit with return code 0
        ret
_MainProc ENDP
END                             ; end of source code
