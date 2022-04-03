;Group : 19I-0605 ,19I-627,19I-723
;;;;Coal - A 
;;;SUBMITED TO SIR ZIA UR REHMAN 

 .model Small
.stack 100h
.data
	
	filename db "abcd.txt", 0
	levellabel db 1 DUP("Total Score: ")
	handler dw ?

	P_one Dw 47
	P_two Dw 13
	Randomno Byte ?   
	Randomrange Byte ?


	Stagesno Byte 1
	Stagesarray Byte 100 Dup(?)  


	Blockr_ Byte ?
	Blockcul Byte ?
	Blockno Byte ?

	R_iter Byte ?		     
	Culter Byte ?		     
	Var1 Byte ?
	Loop_count Byte ?	            

	Showboxclr Byte 9
	Showboxr_ Dw 0
	Showboxcul Dw 0
	Showboxsize Dw 32

	Showstrr_ Byte ?
	Showstrcul Byte ? 
	Showstrculor Byte ?
	 

	Micculpx Dw ?
	Micr_px Dw ?
	Boarbytelockr_ Byte ?
	Boarbytelockcul Byte ?


	Micculstart Dw ?
	Micr_start Dw ?
	Boxfilli Byte ?
	Boxfillo Byte ?


	Windowblockr_ Byte ?
	Windowblockcul Byte ?
	  
	 
	Butoner_ Byte ?
	Butonecul Byte ?
	Butoneindex Byte ?

	Buttwor_ Byte ?
	Buttwocul Byte ? 
	Buttwoindex Byte ?
	Var1index Dw ?
	 
	Arrindex Dw ?

	Var1var Byte ?
	Var1var2 Dw ?
	Sumculs Byte 10
	Sumr_s Byte 10
	R_indexcrush Byte 0
	Culndexcrush Byte 0
	Isvercrush Byte 0
	Ishorizontalcrush Byte 0
	Isbomb Byte 0
	Bombno Byte ?
	Inperpetualcrush Byte 0

	Dropr_ Byte ?
	Dropcul Byte ?
	Var1r_ Byte ?

	Startingindex Dw ?
	Endingindex Dw ?
	Combolength Byte ?


	Lastculndex Byte ?

	Quotient Byte ?
	Remain Byte ?
	Printnocount Byte ?
	Printnoculor Byte ? 
	Printnor_ Byte ?
	Printnocul Byte ?


	Point Dw 0
	Sumpoint Dw 0
	Moves Dw 15


	Enternamemsg Byte "Enter Your Name: ","$"
	Nobercrushmsg Byte "Score","$"
	Enterstagesmsg Byte "Enter Level: ","$"
	Playername Byte 20 Dup(?)
	Squarelength Dw ?	; X-axis
	Squarewidth Dw ?	; Y-axis
	Firstsquarepixels Dw ?

	Adminname Byte "Name:","$"
	Adminmoves Byte "Moves:","$"
	Adminpoint Byte "Score:","$"
	Stagespointmsg Byte "Your Point For This Stages Is", "$"
	Greetyoumsg Byte "Greet You For Playing!", "$"
	Point_endmsg Byte "Your Final Point Is", "$"
 .code
Main Proc
  
    Mov Ax, @data
    Mov Ds, Ax
				
	Call Printfirstwindow	; Ask Player Name And Starting Stages Nober
	
	Startjee1::			
		cmp Stagesno,1
		je Startstagesone
		
		cmp Stagesno,2
		je Startstagestwo
		
		cmp Stagesno,3
		je Startstagesthree
	Startstagesone:
		Call Firstizestagesone
		Jmp Removefirstcombos
	
	Startstagestwo:
		Call Firstizestagestwo
		Jmp Removefirstcombos
	
	Startstagesthree:
		Call Firstizestagesthree
		
	Removefirstcombos:
		Call Horizontaltraversal	; Remove First Horizontal And Ver Combinations
		Call Vertraversal
		
		Cmp Ishorizontalcrush, 1	
		Je Go_got
		Cmp Isvercrush, 1
		Je Go_got
		Jmp Startjee				; If No Combos Exist, Then The Jee Starts
	
	Go_got:
		Call Dropnobers			; Drop Nobers To Replace Crushed Nobers
		Mov Ishorizontalcrush, 0
		Mov Isvercrush, 0
		Jmp Removefirstcombos

	Startjee:	
		Call Showstages 
		Mov Point, 0				; Resetting Point Accumulated During Preliminary Crushing
	
	Jeeloop:
		Call Printjeeinfo		; Printname, Moves, Point
		Call Checkformicclick		
	
		Jmp Jeeloop
	                   
    Exitmain::
    Mov Ah, 4ch
    Int 21h

Main Endp



Firstizestagesone Proc

Push Si
Push Cx
Push Bx
    	
Mov Si, 0
Mov Cx, 100

Mov P_one, 47
Mov P_two, 13
Mov Randomrange, 5		; To Generate Nobers Upto 5
Fillloop:  
    Call Generaterandomomno
    Mov Bl, Randomno
    Mov Stagesarray[si], Bl  
    Inc Si
    Loop Fillloop      

Mov Ah, 0
Mov Al, 12h
Int 10h ; Intrept
		   
Pop Bx
Pop Cx
Pop Si
Ret    
                                                                                                                                                                                                                                                                
Firstizestagesone Endp                                                                                      


Firstizestagestwo Proc

Push Si
Push Bx
Push Ax	;push Ax To Stack
Push Dx
    
Mov Si, 0

Mov Ax, 0	; R_
Mov Dx, 0	; Cul

Mov Randomrange, 5
Mov P_one, 47
Mov P_two, 13

Fillloop_r_:
	Mov Dl, 0
	
	Fillloop_cul:
		Cmp Al, 2				; Check If R_ Is 0,1,2 
		Jbe Checkcornerx_axis
		Cmp Al, 7				; Check If R_ Is 7,8,9
		Jae Checkcornerx_axis
		Cmp Al, 4				; Check If R_ Is 4
		Je Checkcentrex_axis	
		Cmp Al, 5				; Check If R_ Is 5
		Je Checkcentrex_axis	
		Jmp Genno
	
		Checkcornerx_axis:	; Check If Cul Is 0,1,2 Or 7,8,9 
			Cmp Dl, 2
			Jbe Genblankno
			Cmp Dl, 7
			Jae Genblankno
			Jmp Genno
		
		Checkcentrex_axis:	; Checks If Cul Is Between 3-7
			Cmp Dl, 3
			Jb Genno
			Cmp Dl, 6
			Ja Genno
	
		Genblankno:
			Push Ax	;push Ax To Stack
			Push Dx;push Dx To Stack
			
			Mov Dl, Sumr_s
			Mul Dl
			
			Pop Dx;pop Dx To Stack
			Add Al, Dl
			Mov Si, Ax
			Pop Ax ;pop Ax To Stack
								
			Mov Stagesarray[si], 7  
			Jmp Go_got
		
		Genno:
			Push Ax	;push Ax To Stack
			Push Dx;push Dx To Stack
			
			Mov Dl, Sumr_s
			Mul Dl
			
			Pop Dx;pop Dx To Stack
			Add Al, Dl
			Mov Si, Ax
			Pop Ax ;pop Ax To Stack
						
			Call Generaterandomomno
			Cmp Randomno, 1
			Je Filln
			Dec Randomno
			
			Filln:
				Mov Bl, Randomno		
				Mov Stagesarray[si], Bl  

		Go_got:
			Inc Dl
			Cmp Dl, 10
			Jne Fillloop_cul
		
		Inc Al
		Cmp Al, 10
		Jne Fillloop_r_
  
Pop Dx
Pop Ax  
Pop Bx
Pop Si
Ret    
                                                                                                                                                                                                                                                                
Firstizestagestwo Endp  


Firstizestagesthree Proc

Push Si
Push Cx
Push Bx
    
Mov Si, 0
Mov Cx, 100

Mov Randomrange, 6		; To Generate Nobers Upto 5
Mov P_one, 47
Mov P_two, 13
Fillloop:  
    Call Generaterandomomno
    Mov Bl, Randomno
	Cmp Bl, 6
	Jne Normalno
    Mov Stagesarray[si], 'x'		; If Randomno = 6, Generate A Blocker
	Jmp Go_got
	
	Normalno:		; Nober Between 1-5
		Mov Stagesarray[si], Bl
	
	Go_got:
		Inc Si
		Loop Fillloop      
    
Pop Bx
Pop Cx
Pop Si
Ret    		  
Firstizestagesthree Endp    
         

Generaterandomomno Proc     
    
    Push Ax	;push Ax To Stack
    Push Bx
	Push Cx;push Cx To Stack
    Push Dx
    
	Genagain:
		Mov Ax, P_one  
		Mov Bx, 1
		Mul Bx
		
		Add Ax, P_two 
		Mov Bh, Randomrange
		Div Bh
				  
		Mov Randomno, Ah
		Inc Randomno             
		
		Cmp Isbomb, 1		; If Bomb Blew, Dont Generate The Bombed Nober
		Jne Go_got
		Mov Cl, Randomno
		Cmp Cl, Bombno
		Jne Go_got
		Mov P_one, Ax
		Mov P_two, Dx
		Jmp Genagain
	
	Go_got:
		Mov P_one, Ax
		Mov P_two, Dx

    Pop Dx
	Pop Cx;pop Cx To Stack
    Pop Bx
    Pop Ax 
    Ret
        
Generaterandomomno Endp


Showblock Proc
    
    Push Ax	;push Ax To Stack
    Push Bx
    Push Cx
    Push Dx
        
    Mov Dh, Blockr_
    Mov Dl, Blockcul
    
    Mov Ah, 02 ;printh		  ; Move Cursor To Blockr_, Blockcul
    Int 10h ; Intrept
    
    Mov Al, Blockno   ; Al = Nober To Print   
	Cmp Al, 0	   
	Je Showzero
	
	Cmp Al, '8'
	Je Showbomb
	
	Cmp Al, 'x'
	Jne Go_got
	
	Mov Bl, 0fh		  ; Showing Blocker
	Mov Al, 'x'
	Mov Bh, 0
	Mov Cx, 1
	Jmp Exit
		
	Showbomb:
		Mov Bl, 0dh		  ; Showing Bomb
		Mov Al, '8'
		Mov Bh, 0
		Mov Cx, 1
		Jmp Exit
	
	Showzero:		
		Mov Bl,	0eh
		Jmp Go_next
	
	Go_got:
		Mov Bl, Al        
	Go_next:
		Add Al, 48		  ; Blockno Has Nober. Adding 48 To Get Ascii Value Of The Nober
		Mov Bh, 0		  ; Page Nober = 0
		Mov Cx, 1		  ; Printonce
    
	Exit:
    Mov Ah, 9h
    Int 10h ; Intrept    
    
    Pop Dx
    Pop Cx
    Pop Bx
    Pop Ax
    Ret
    
Showblock Endp     
 

Showredoutline Proc

	Push Ax	;push Ax To Stack
	Push Bx
	Push Cx;push Cx To Stack
	Push Dx;push Dx To Stack

	; Go_top Go_left
	Mov Showboxr_, 88
	Mov Showboxcul, 148
	Mov Showboxsize, 96
	Mov Showboxclr, 0ch
	Call Showbox

	Inc Showboxcul
	Call Showbox

	Inc Showboxr_
	Call Showbox

	; Go_top Right
	Mov Showboxr_, 88
	Mov Showboxcul, 370

	Inc Showboxcul
	Call Showbox

	Inc Showboxcul
	Call Showbox

	Inc Showboxr_
	Call Showbox

	; Down Go_left
	Mov Showboxr_, 311
	Mov Showboxcul, 147

	Inc Showboxcul
	Call Showbox

	Inc Showboxcul
	Call Showbox

	Inc Showboxr_
	Call Showbox

	;down Right
	Mov Showboxr_, 311
	Mov Showboxcul, 370

	Inc Showboxcul
	Call Showbox

	Inc Showboxcul
	Call Showbox

	Inc Showboxr_
	Call Showbox
	
	;middle
	Mov Cx, 243	; Cul
	Mov Dx, 216	; R_
	Go_top:				; Go_top Horizontal Line
		Cmp Cx, 372
		Ja Go_next
	
		Mov Ah, 0ch
		Mov Bh, 0
		Mov Al, 0ch
		Int 10h ; Intrept
		
		Dec Dx
		Mov Ah, 0ch
		Mov Bh, 0
		Mov Al, 0ch
		Int 10h ; Intrept
		Inc Dx
		
		Inc Cx
		Jmp Go_top
		
	Go_next:	
	Mov Cx, 244	; Cul
	Mov Dx, 216	; R_
	
	Go_left:	; Go_left Ver Line
		Cmp Dx, 280
		Ja Go_next2
	
		Mov Ah, 0ch
		Mov Bh, 0
		Mov Al, 0ch
		Int 10h ; Intrept
		
		Dec Cx
		Mov Ah, 0ch
		Mov Bh, 0
		Mov Al, 0ch
		Int 10h ; Intrept
		Inc Cx
		
		Inc Dx
		Jmp Go_left

	Go_next2:
	Mov Cx, 244	; Cul
	Mov Dx, 280	; R_
	
	Down:	; Down Horizontal Line
		Cmp Cx, 372
		Ja Go_next3
	
		Mov Ah, 0ch
		Mov Bh, 0
		Mov Al, 0ch
		Int 10h ; Intrept
		
		Dec Dx
		Mov Ah, 0ch
		Mov Bh, 0
		Mov Al, 0ch
		Int 10h ; Intrept
		Inc Dx
		
		Inc Cx
		Jmp Down
	
	Go_next3:
	Mov Cx, 372	; Cul
	Mov Dx, 216	; R_
	
	Right:	; Right Ver Line
		Cmp Dx, 280
		Ja Finish
	
		Mov Ah, 0ch
		Mov Bh, 0
		Mov Al, 0ch
		Int 10h ; Intrept
		
		Dec Cx
		Mov Ah, 0ch
		Mov Bh, 0
		Mov Al, 0ch
		Int 10h ; Intrept
		Inc Cx
		
		Inc Dx
		Jmp Right
	
	Finish:
		Pop Dx;pop Dx To Stack
		Pop Cx;pop Cx To Stack
		Pop Bx
		Pop Ax ;pop Ax To Stack
		Ret
Showredoutline Endp   
 

Showboardgrid Proc
	Push Ax	;push Ax To Stack
	Push Bx
	Push Cx;push Cx To Stack
	Push Dx;push Dx To Stack
	Push Si
	
	Mov Showboxclr, 9
	Mov Showboxr_, 88
	Mov Showboxcul, 148
	Mov Showboxsize, 32
	Mov Loop_count, 0
	Mov Dx, Showboxsize

	Mov Si, 0
	Showloop:
		Cmp Loop_count, 10
		Je Finishprint   
		
		Mov Cx, 10
		Printr_:
			Cmp Stagesarray[si], '8'
			Je Setbombblockculor
			Cmp Stagesarray[si], 'x'
			Jne Go_got
			Mov Showboxclr, 0fh	; Set Block Culor To White For Blockers
			Jmp Go_got
			
			Setbombblockculor:
				Mov Showboxclr, 0dh	; Set Culor For Bomb
		
			Go_got:
				Call Showbox  
				Add Showboxcul, 32
				Mov Showboxclr, 9
				Inc Si
				Loop Printr_
	 
		Add Showboxr_, 32
		Mov Showboxcul, 148
		Inc Loop_count
		Jmp Showloop
	 
	Finishprint:   
		Cmp Stagesno, 2
		Jne Finish
		Call Showredoutline		
	Finish:
		Pop Si
		Pop Dx;pop Dx To Stack
		Pop Cx;pop Cx To Stack
		Pop Bx
		Pop Ax ;pop Ax To Stack 
		Ret   
          
Showboardgrid Endp 
 
   
Showstages Proc 
   
   Push Si
   
   Mov Ah, 0h            ; Set Window To 640x480
   Mov Al, 12h
   Int 10h ; Intrept     
   
   Mov Blockr_, 6		
   Mov Blockcul, 20
  
   Mov Si, 0			; To Access Array Elements
   Mov R_iter, 0		; For Outer Loop Over R_s
   Mov Culter, 0		; For Inner Loop Over X_axis
   
   Mov Al, Blockcul		; Saving Blockcul So It Can Be Restored After Looping Over 10 Culs Of A R_
   Mov Var1, Al
   
	R_loop:
		Mov Culter, 0
		
		Culloop:
			Cmp Stagesno, 2				; If Stages 2, Restrict Traversal To Only Accessible Areas 
			Jne Show
			
			Cmp R_iter, 2				; Check If R_ Is 0,1,2 
			Jbe Checkcornerx_axis
			Cmp R_iter, 7				; Check If R_ Is 7,8,9
			Jae Checkcornerx_axis
			Cmp R_iter, 4				; Check If R_ Is 4
			Je Checkcentrex_axis	
			Cmp R_iter, 5				; Check If R_ Is 5
			Je Checkcentrex_axis	
			Jmp Show
	
		Checkcornerx_axis:				; Check If Cul Is 0,1,2 Or 7,8,9 
			Cmp Culter, 2
			Jbe Go_nextiter
			Cmp Culter, 7
			Jae Go_nextiter
			Jmp Show
		
		Checkcentrex_axis:				; Checks If Cul Is Between 3-7
			Cmp Culter, 3
			Jb Show
			Cmp Culter, 6
			Ja Show		
			Jmp Go_nextiter
     
        Show:
            Mov Dh, Stagesarray[si]		; Printextracted Nober From Stagesarray
			Cmp Dh, 7
			Jb Go_on					; 7 Is Placed In Restricted Areas So Is Skipped
			Cmp Dh, '8'
			Je Go_on
			Cmp Dh, 'x'
			Je Go_on
			Jmp Go_nextiter
			
		Go_on:	
			Mov Blockno, Dh
			Call Showblock
	
		Go_nextiter:
			Add Blockcul, 4
			Inc Si
			
			Inc Culter
			Cmp Culter, 10
			Jb Culloop
    
		Mov Al, Var1
		Mov Blockcul, Al		; Restoring Nober Of X_axis
		Add Blockr_, 2
		Inc R_iter
		Cmp R_iter, 10
		Jb R_loop
	
    Call Showboardgrid        ; Shows Hollow Squares Around Each Nober
    Pop Si
	Ret

Showstages Endp 



Showbox Proc

	Push Dx;push Dx To Stack
	Push Cx;push Cx To Stack
	Push Ax	;push Ax To Stack
	
	Mov Bx, 0
	Mov Ax, Showboxsize              ; Length Of Line In Pixels
	Mov Dx, Showboxr_
	Mov Cx, Showboxcul
	
	Push Cx;push Cx To Stack
	Push Dx;push Dx To Stack
	Push Ax	;push Ax To Stack
	Call Printhorizontalline
	Call Printverline  
	
	Pop Ax ;pop Ax To Stack
	Pop Dx;pop Dx To Stack
	Add Dx, Ax
	Dec Dx
	Push Dx;push Dx To Stack
	Push Ax	;push Ax To Stack
	Call Printhorizontalline
	
	Pop Ax ;pop Ax To Stack
	Pop Dx;pop Dx To Stack
	Mov Dx, Showboxr_
	Pop Cx;pop Cx To Stack
	Add Cx, Ax   
	Dec Cx
	Push Cx;push Cx To Stack
	Push Dx;push Dx To Stack
	Push Ax	;push Ax To Stack
	Call Printverline
	 
	Pop Ax ;pop Ax To Stack
	Pop Dx;pop Dx To Stack 
	Pop Cx;pop Cx To Stack 
	Pop Ax ;pop Ax To Stack
	Pop Cx;pop Cx To Stack 
	Pop Dx;pop Dx To Stack  
	
	
	
	Ret
	
Showbox Endp

;---------------------------------------------------------------------------------------------------------------------------------------
Printhorizontalline Proc   
    Push Bp     
    Mov Bp, Sp
   
    Mov Bx, [bp + 4]	; Showboxsize
    Mov Dx, [bp + 6]
    Mov Cx, [bp + 8]
    
	Push Ax	;push Ax To Stack
	
	Mov Ax, 0
	
	Printline:
		Cmp Ax, Bx
		Je Exitprintline
		
		Push Ax	;push Ax To Stack
		Mov Ah, 0ch 
		Mov Bh, 0
		Mov Al, Showboxclr
		Int 10h ; Intrept
		         
	    Pop Ax	         
		Inc Ax
		Inc Cx
		Jmp Printline
	
	Exitprintline:
		Pop Ax ;pop Ax To Stack    
		Pop Bp
		Ret 
		
Printhorizontalline Endp

;----------------------------------------------------------------------------------------------------------------------------------------
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;| Printverline |;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;----------------------------------------------------------------------------------------------------------------------------------------
; Shows A Ver Line Using Values Pushed On Stack
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Printverline Proc
	Push Bp     
    Mov Bp, Sp
   
    Mov Bx, [bp + 4]
    Mov Dx, [bp + 6]
    Mov Cx, [bp + 8]

	Push Ax	;push Ax To Stack
	
	Mov Ax, 0
	
	Printlinea:
		Cmp Ax, Bx
		Je Exitprintlinea
		   
		Push Ax	;push Ax To Stack   
		Mov Ah, 0ch
		Mov Bh, 0
		Mov Al, Showboxclr
		Int 10h ; Intrept
		
		Pop Ax ;pop Ax To Stack
		Inc Ax
		Inc Dx
		Jmp Printlinea
	
	Exitprintlinea:
		Pop Ax ;pop Ax To Stack    
		Pop Bp
		Ret
		
Printverline Endp

;----------------------------------------------------------------------------------------------------------------------------------------
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;| Showstring |;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;----------------------------------------------------------------------------------------------------------------------------------------
; Shows A String On Showstrr_, Cul Where The String Address Is Go_gotained In Si
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Showstring Proc
	Push Ax	;push Ax To Stack
	Push Bx
	Push Dx;push Dx To Stack
		
	Mov Dh, Showstrr_
	Mov Dl, Showstrcul
	
	Showloop:
		Mov Ah, [si]
		Cmp Ah, '$'
		Je Exit
		
		Mov Ah, 02 ;printh
		Int 10h ; Intrept

		Mov Ah, 09h
		Mov Al, [si]
		Mov Bh, 0
		Mov Bl, Showstrculor 
		Mov Cx, 1
		Int 10h ; Intrept
		
		Inc Dl
		Inc Si
		Jmp Showloop
Exit:
	Pop Dx;pop Dx To Stack
	Pop Bx
	Pop Ax ;pop Ax To Stack
	Ret
	
Showstring Endp  
 

Printjeeinfo Proc
    
    Push Si
    
    Mov Showstrr_, 0
    Mov Showstrcul, 0
    Mov Showstrculor, 4
    Lea Si, Adminname
    Call Showstring  

	Call Printplayername
	
	; Mov Showstrr_, 0
 
	
    Mov Showstrr_, 0			; Printmoves String
    Mov Showstrcul, 35 
    Mov Showstrculor, 2
    Lea Si, Adminmoves
    Call Showstring  

	Mov Ax, Moves				; Showing Moves
	Mov Printnoculor, 0ah
	Mov Printnocul, 42
	Mov Printnor_, 0
	Call Diplaymultidigitnober
	
    Mov Showstrr_, 0			; Showing Point String
    Mov Showstrcul, 68
    Mov Showstrculor, 3
    Lea Si, Adminpoint
    Call Showstring
	
	Mov Ax, Point				; Showing Point
	Mov Printnoculor, 0bh
	Mov Printnocul, 75
	Mov Printnor_, 0
	Call Diplaymultidigitnober
	
    Pop Si
    Ret 

Printjeeinfo Endp 


Boarbytelocktowindowblock Proc
	Push Ax	;push Ax To Stack
	Push Bx

	Mov Al, Boarbytelockcul
	Mov Bl, 4
	Mul Bl
	Add Al, 20
	Mov Windowblockcul, Al
	
	Mov Al, Boarbytelockr_
	Mov Bl, 2
	Mul Bl
	Add Al, 6
	Mov Windowblockr_, Al
	
	Pop Bx
	Pop Ax ;pop Ax To Stack
	Ret
Boarbytelocktowindowblock Endp 
 

Pixeltoblock Proc
	Push Ax	;push Ax To Stack
	Push Bx
	
	Sub Micculpx, 148				
	Sub Micr_px, 88
    
    Cmp Micculpx, 0              
    Jne Go_next 
    Mov Boarbytelockcul, 0
    Jmp Go_got
   
    Go_next:  
	Mov Ax, 0
	Mov Ax, Micculpx
	Mov Bl, 32
	Div Bl
	Mov Boarbytelockcul, Al
    
    Go_got:
    Cmp Micr_px, 0
    Jne Go_next2
    Mov Boarbytelockr_, 0
    Jmp Retfn 
    
    Go_next2:
	Mov Ax, 0
	Mov Ax, Micr_px
	Div Bl
	Mov Boarbytelockr_, Al
    
    Retfn:
	Pop Bx
	Pop Ax ;pop Ax To Stack
	Ret

Pixeltoblock Endp
	
;----------------------------------------------------------------------------------------------------------------------------------------

Blockgo_topixel Proc
    Push Ax	;push Ax To Stack
    Push Dx
    
    Mov Ax, 0
    Mov Al, 32
    Mul Boarbytelockcul
    
    Add Ax, 148
    Mov Micculpx,ax
    
    Mov Ax, 0
    Mov Al, 32
    Mul Boarbytelockr_
    
    Add Ax, 88
    Mov Micr_px, Ax  
    
    Pop Dx
    Pop Ax
    Ret
	
Blockgo_topixel Endp	

;----------------------------------------------------------------------------------------------------------------------------------------

Checkformicclick Proc
	Mov Ax, 1			; Show Cursor

	Int 33h

	Mov Ax, 3			; Get Button Status And Mic Cursor Coordinates

	Int 33h
	
	Cmp Bx, 1			; Check If Go_left Mic Button Pressed

	Je Checkmicpix
	Jmp Exit
	
	Checkmicpix:
		Mov Micculpx, Cx
		Mov Micr_px, Dx
		
		Cmp Micculpx, 148		; Proceed Only If Mic Coordinates Are Within The Jee Board
		Jb Exit
		
		Cmp Micculpx, 468
		Ja Exit
		
		Cmp Micr_px, 88
		Jb Exit

		Cmp Micr_px, 408
		Ja Exit
		
		Cmp Stagesno, 2
		Jne Go_got
		
		; Ensuring Mic Pointer Is Not Within Restricted Areas Of Stages 2
		
		Cmp Micr_px, 184				; Check If R_ Is Equal To 2 Or Below 
		Jbe Checkcornerx_axis
		
		Cmp Micr_px, 312				; Check If R_ Is Equal To 7 Or Above
		Jae Checkcornerx_axis
		
		Cmp Micr_px, 216				; Check If R_ Is Equal To 4 Or 5
		Jb Go_got	
		
		Cmp Micr_px, 280				
		Ja Go_got	
		Jmp Checkcentrex_axis
	
		Checkcornerx_axis:				; Check If Cul Is 0,1,2 Or 7,8,9 
			Cmp Micculpx, 244
			Jbe Exit
			
			Cmp Micculpx, 372
			Jae Exit
			Jmp Go_got
		
		Checkcentrex_axis:				; Checks If Cul Is Between 3-7
			Cmp Micculpx, 244
			Jna Go_got
			
			Cmp Micculpx, 372
			Ja Go_got
			Jmp Exit
			
		Go_got:
			Call Pixeltoblock		; Go_goverts Mic Coordinates To Get Boarbytelock
			Call Blockgo_topixel		; Gets The First Pixel Coordinates Of The Above Block
				
			Mov Ax, Micculpx		
			Mov Showboxcul, Ax
			Mov Ax, Micr_px
			Mov Showboxr_, Ax
			Mov Showboxclr, 10
			Mov Showboxsize, 32
			Call Showbox			; Show Border Around Relevant Block
			
			Inc Showboxcul		
			Call Showbox			; Thicken The Border
			
			Call Boarbytelocktoarrayindex	; Get Array Index Of The Block Where First Click Occured
			Mov Ax, Arrindex
			Mov Butoneindex, Al
			Mov Ah, Boarbytelockcul		; Store Data Of The First Click For Later Use
			Mov Butonecul, Ah
			Mov Ah, Boarbytelockr_
			Mov Butoner_, Ah

			Call Checkformicrelease
				
	Exit:
		Ret

Checkformicclick Endp 




Checkformicrelease Proc
	
	Checkloop:
		Mov Ax, 3			
		Int 33h

		Cmp Bx, 0	
		Jne Checkloop
		
		Mov Micculpx, Cx
		Mov Micr_px, Dx
		
		Cmp Micculpx, 148		
		
		Jb Exit
		
		Cmp Micculpx, 468
		Ja Exit
		
		Cmp Micr_px, 88
		Jb Exit

		Cmp Micr_px, 408
		Ja Exit
		
		Cmp Stagesno, 2
		Jne Go_got
		
		Cmp Micr_px, 184				 
		Jbe Checkcornerx_axis
		
		Cmp Micr_px, 312				
		Jae Checkcornerx_axis
		
		
		
		Cmp Micr_px, 216
		Jb Go_got	
		
		Cmp Micr_px, 280				
		Ja Go_got	
		Jmp Checkcentrex_axis
	
		Checkcornerx_axis:				
			Cmp Micculpx, 244
			Jbe Exit
			
			Cmp Micculpx, 372
			Jae Exit
			Jmp Go_got
		
		Checkcentrex_axis:				
			Cmp Micculpx, 244
			Jna Go_got
			
			Cmp Micculpx, 372
			Ja Go_got
			Jmp Exit
			
		Go_got:
		Call Pixeltoblock

		Call Blockgo_topixel		
		
		
		Mov Ax, Micculpx		
		Mov Showboxcul, Ax
		Mov Ax, Micr_px
		Mov Showboxr_, Ax
		Mov Showboxclr, 10
		Mov Showboxsize, 32
		Call Showbox

		Inc Showboxcul		
		Call Showbox
			
		Call Boarbytelocktoarrayindex
		Mov Ax, Arrindex
		Mov Buttwoindex, Al
		Mov Ah, Boarbytelockcul		
		Mov Buttwocul, Ah
		Mov Ah, Boarbytelockr_
		Mov Buttwor_, Ah
		
		Call Checkswapposi			
		Ret
		
	Exit:   
		Mov Showboxclr, 9
		Call Showboardgrid
		Ret
Checkformicrelease Endp




Boarbytelocktoarrayindex Proc

	Push Ax	;push Ax To Stack
	Push Bx
 	
	Mov Al, Boarbytelockr_
	Mov Bl, 10
	Mul Bl
	
	Mov Bh, 0
	Mov Bl, Boarbytelockcul
	
	Add Ax, Bx 
	Mov Arrindex, Ax
	
	Pop Bx
	Pop Ax ;pop Ax To Stack
	Ret
	
Boarbytelocktoarrayindex Endp


Boxfill Proc
	Push Cx;push Cx To Stack
	Push Dx;push Dx To Stack
	Push Ax	;push Ax To Stack
		
	Mov Boxfillo, 0
	Mov Cx, Micculstart
	Mov Dx, Micr_start
	
	Outerloop:
		Mov Boxfilli, 0
		
		Innerloop:
			Mov Ah, 0ch
			Mov Al, 09h
			Int 10h ; Intrept
			Inc Boxfilli
			Inc Cx
			Cmp Boxfilli, 32
			Jb Innerloop
		
		Mov Cx, Micculstart
		Inc Dx
		Inc Boxfillo
		Cmp Boxfillo, 32
		Jb Outerloop
	
	Pop Ax ;pop Ax To Stack
	Pop Dx;pop Dx To Stack
	Pop Cx;pop Cx To Stack
	Ret
Boxfill Endp

 
Checkswapposi Proc

	Mov Ah, Butonecul
	Mov Al, Butoner_

	Mov Bh, Buttwocul
	Mov Bl, Buttwor_

	Cmp Ah, Bh		


	Jne Samer_
	
	Samecul:
		Cmp Bl, Al 			
		
		
		Ja Sego_godr_larger
		
		Cmp Bl, Al
		
		Jb Sego_godr_smaller	
		
		Jmp Exit			
		Sego_godr_larger:	
		


		Mov Cl, Bl	
		
			Mov Dl, Al	
			
		Sub Cl, Dl
			
			
			Cmp Cl, 1	
			
			Jne Exit
			
			
			Cmp Bl, 9		
			
			Ja Exit			
			
			Call Swapblocks
			Jmp Exit
			
		Sego_godr_smaller:  
			
			Mov Cl, Bl		
			
			Mov Dl, Al		
			
			Sub Dl, Cl
			
			Cmp Dl, 1	
			
			Jne Exit
			Cmp Bl, 0		
			
			Jb Exit			
			
			Call Swapblocks
			Jmp Exit
	
	Samer_:
		Cmp Al, Bl		; If R_s Are Same
		Je Checkcul
		Jmp Exit
		
	Checkcul:
		Cmp Bh,ah
		Ja Sego_godcullarger


		Cmp Bh, Ah

		Jb Sego_godculsmaller	
		
		Jmp Exit
		
		Sego_godcullarger:
			Mov Cl, Bh		; Cl = Larger Cul
			Mov Dl, Ah		; Dl = Smaller Cul
			Sub Cl, Dl
			Cmp Cl, 1		; Check If Block Below Is Only At A Single Block Distance
			Jne Exit
			Cmp Bh, 9
			Ja Exit			; Checking If Block Is Out Of Bounds
			
			Call Swapblocks
			Jmp Exit
		
		Sego_godculsmaller:
			Mov Cl, Bh		; Cl = Smaller Cul
			Mov Dl, Ah		; Dl = Larger Cul
			Sub Dl, Cl
			Cmp Dl, 1		; Check If Block Above Is Only At A Single Block Distance
			Jne Exit
			Cmp Bl, 0
			Jb Exit			; Checking If Block Is Out Of Bounds
			
			Call Swapblocks
			Jmp Exit
	
	Exit:				
		Mov Showboxclr, 9	; If Swap Not Possible, Reshow Original Border Around Highlighted Blocks
		Call Showboardgrid		
		Ret

Checkswapposi Endp


Swapblocks Proc
	Push Ax	;push Ax To Stack
	Push Bx
	Push Cx;push Cx To Stack
	Push Dx;push Dx To Stack
	Push Si

	Mov Bh, 0				
	Mov Bl, Butoneindex
	Mov Si, Bx
	Mov Var1index, Bx
	
	Mov Dh, Stagesarray[si]	; Dh = Value Of Block Where Mic Was Clicked
	
	Mov Bh, 0
	Mov Bl, Buttwoindex		
	Mov Si, Bx
		
	Mov Cl, Stagesarray[si]	
	
	Cmp Dh, 'x'	
	Je Exitifblocker
	Cmp Cl, 'x'
	Je Exitifblocker
	Je Checkbombfirst
	Jmp Checkbombsego_god	
	
	Checkbombfirst:		
		Cmp Cl, '8'		
		Je Ifbomb
		
		Mov Al, Cl		
		Call Blast_bomb
		Call Showstages
		Call Dropnobers
		Jmp Normalfinish
		
		Ifbomb:			
			Mov Showboxclr, 9
			Call Showboardgrid
			Jmp Normalfinish
	
	Checkbombsego_god:    
		Cmp Cl, '8'		
		Jne Swap		
		Mov Al, Dh		; Dh = Nober, Cl = Bomb
		Call Blast_bomb
		Call Showstages
		Call Dropnobers
		Jmp Normalfinish
		
	Swap:
		Mov Stagesarray[si], Dh		; Swapping Values
		Mov Si, Var1index
		Mov Stagesarray[si], Cl
		
	Normalfinish:	
		Call Perpetualcrushing
		Dec Moves				
		Cmp Moves, 0			; If Admin Runs Out Of Moves, Go The Go_next Stages If Possible
		Jne Exitifblocker		

		Cmp Stagesno, 3		
		Jb Gotogo_nextstages		
		Call Printendwindow ;end The Game
		Gotogo_nextstages:
			Call Loadgo_nextstages
		
		
		
	Exitifblocker:	
	 	Mov Ax, 1
		Int 33h

		Pop Si
		Pop Dx;pop Dx To Stack
		Pop Cx;pop Cx To Stack
		Pop Bx
		Pop Ax ;pop Ax To Stack
	Ret	

Swapblocks Endp
 


Onesecdelay Proc
	Push Ax	;push Ax To Stack
	Push Cx;push Cx To Stack
	Push Dx;push Dx To Stack
	
	Mov Cx, 0fh				; Add Time Delay Of 1 Sec
	Mov Dx, 4240h
	Mov Ah, 86h
	Int 15h 		

	Pop Dx;pop Dx To Stack
	Pop Cx;pop Cx To Stack
	Pop Ax ;pop Ax To Stack
	Ret
Onesecdelay Endp  


Loadgo_nextstages Proc
	Push Ax	;push Ax To Stack
	Mov Ah, 0		; Clear The Window
	Mov Al, 12h
	Int 10h ; Intrept
	
	Call Printnoberborder;print The Number Border; Printthe Border Of Nobers Around Jee Board
	Call Showboxborder
	
	Mov Showstrcul, 23			; Write "Your Point For This Stages Is"
	Mov Showstrr_, 14
	Mov Showstrculor, 0eh
	Lea Si, Stagespointmsg
	Call Showstring
	
	Mov Printnocul, 52		; Printthe Point
	Mov Printnor_, 14
	Mov Printnoculor, 0eh
	Mov Ax, Point
	Call Diplaymultidigitnober	
	
	Call Onesecdelay			; 3 Sec Delay To Allow Admin To View Point
	Call Onesecdelay
	Call Onesecdelay
	
	
	Call Showboardgrid
	call writting
	Cmp Stagesno, 3				; Go To Go_next Stages If Available, Else, Exit The Jee
	Je Exitmain
	Inc Stagesno
	Mov Ax, Point
	Add Sumpoint, Ax			; Add Point To Sumpoint
	Mov Point, 0				; Reset Point For The Go_next Stages
	Mov Moves, 15				; Reset Moves To 15 For Go_next Stages
	Jmp Startjee1
	
	Pop Ax ;pop Ax To Stack
	Ret

Loadgo_nextstages Endp 
 
 
writting proc
		;CREATE FILE.
  mov  ah, 3ch
  mov  cx, 0
  mov  dx, offset filename
  int  21h  

;PRESERVE FILE HANDLER RETURNED.
  mov  handler, ax

;WRITE STRING.
  mov  ah, 40h
  mov  bx, handler
  mov  cx, Lengthof Playername  ;STRING LENGTH.
  mov  dx, offset Playername
  int  21h
  
  mov  ah, 40h
  mov  bx, handler
  mov  cx, 1 ;STRING LENGTH.
  mov  dx, 10
  int  21h
  
  mov  ah, 40h
  mov  bx, handler
  mov  cx, Lengthof Sumpoint  ;STRING LENGTH.
  mov  dx, offset Sumpoint
  int  21h
  
  
  mov  ah, 40h
  mov  bx, handler
  mov  cx, Lengthof levellabel  ;STRING LENGTH.
  mov  dx, offset levellabel
  int  21h

;CLOSE FILE (OR DATA WILL BE LOST).
  mov  ah, 3eh
  mov  bx, handler
  int  21h

ret
writting endp 
 
  
Horizontaltraversal Proc
	Push Bx
	Push Ax	;push Ax To Stack
	Push Si
		
	Mov Bx, 0
	Mov Ax, 0
	Mov Si, 0
	
	Mov R_indexcrush, 0
	R_loop:
		
		Mov Culndexcrush, 0
		
		Fullculloop:
			Cmp Stagesno, 2
			Jne Culloop
	
			Cmp R_indexcrush, 2				; Check If R_ Is 0,1,2 
			Jbe Checkcornerx_axis
			Cmp R_indexcrush, 7				; Check If R_ Is 7,8,9
			Jae Checkcornerx_axis
			Cmp R_indexcrush, 4				; Check If R_ Is 4
			Je Checkcentrex_axis	
			Cmp R_indexcrush, 5				; Check If R_ Is 5
			Je Checkcentrex_axis	
			Jmp Culloop
		
		Checkcornerx_axis:					; Check If Cul Is 0,1,2 Or 7,8,9 
			Cmp Culndexcrush, 2
			Jbe Go_got
			Cmp Culndexcrush, 7
			Jae Go_got
			Jmp Culloop
		
		Checkcentrex_axis:					; Checks If Cul Is Between 3-7
			Cmp Culndexcrush, 3
			Jb Culloop
			Cmp Culndexcrush, 6
			Ja Culloop
			Jmp Go_got
			
		Culloop:
			Mov Bl, R_indexcrush
			Mov Al, Sumculs
			Mul Bl
			Mov Bx, Ax
			Mov Dx, 0
			Mov Dl, Culndexcrush
			Mov Si, Dx
			
			Call Horizontalcrush		; Calling For Every Index To See If It Makes A Combination
			
		Go_got:
			Inc Culndexcrush
			Cmp Culndexcrush, 10
			Jb Fullculloop
		
		Inc R_indexcrush
		Cmp R_indexcrush, 10
		Jb R_loop
		
	Pop Si
	Pop Ax ;pop Ax To Stack
	Pop Bx
	
	Ret		
Horizontaltraversal Endp

 
Horizontalcrush Proc
	Mov Di, Si
	Cmp Culndexcrush, 8		; Index Should Be Less Than 8(3 Nober Crush)
	Jb Checkcrush
	Jmp Exit

	Checkcrush:
		Push Bx	
		Add Bx, Si
		Mov Startingindex, Bx		; Firstizing Var For Removeblockershorizontally
		Pop Bx
		Mov Al, Stagesarray[bx+si]		; Comparison With Go_next Value
		Cmp Al, '8'						
		
		Je Exit							; Dont Check For Combinations Of Bombs Or Blockers
		
		
		Cmp Al, 'x'
		
		
		Je Exit
		
		Inc Si
		Cmp Al, Stagesarray[bx+si]
		Je Checkgo_nextvalue		  



		Jmp Exit

	Checkgo_nextvalue:
		Inc Si
		Cmp Al, Stagesarray[bx+si]
		Je Fillzero			
		Jmp Exit

	Fillzero:
		Mov Ishorizontalcrush, 1


		Mov Combolength, 3			


		Add Point, 3
		
		Go_got:
			Mov Si, Di
			Mov Stagesarray[bx+si], 0
			Inc Si
			Mov Stagesarray[bx+si], 0
			Inc Si
			Mov Stagesarray[bx+si], 0
	
	Crushall:
		Inc Si
		Cmp Si, 10				; Checking If Value Of Si Is Within The Limits	
		Jb Checkabovethreecombo
		Jmp Endfn

	Checkabovethreecombo:
		Cmp Al, Stagesarray[bx+si]	; Checking If The Other Nobers Match
		Je Placebomb
		Jmp Endfn		
	
	Placebomb:							
		Inc Combolength
		Inc Point
		Mov Stagesarray[bx+si-1], 0		
		Mov Stagesarray[bx+si], '8'		
		Jmp Crushall

	Endfn:
		Push Bx
		Add Bx, Si
		Dec Bx
		
		Mov Endingindex, Bx	
		
		Pop Bx
		
		Cmp Stagesno, 3
		Jne Exit
		
		Call Removeblockershorizontally	
		Exit:
			Mov Si, Di
			Ret

Horizontalcrush Endp	
	

Vertraversal Proc
	Push Bx
	Push Ax	;push Ax To Stack
	Push Si
	Push Dx;push Dx To Stack
		
	Mov Bx, 0
	Mov Ax, 0
	Mov Si, 0
	
	Mov Culndexcrush, 0
	Culloop:
		
		Mov Dx, 0
		Mov Dl, Culndexcrush
		Mov Si, Dx
		Mov R_indexcrush, 0
			
		Fullr_loop:
			Cmp Stagesno, 2
			Jne R_loop
	
			Cmp R_indexcrush, 2				
			
			
			Jbe Checkcornerx_axis
			
			Cmp R_indexcrush, 7				
			
			Jae Checkcornerx_axis
			
			Cmp R_indexcrush, 4				
			
			Je Checkcentrex_axis	
			
			Cmp R_indexcrush, 5
			Je Checkcentrex_axis	
			Jmp R_loop
		
		Checkcornerx_axis:
			
			Cmp Culndexcrush, 2
			Jbe Go_got
			Cmp Culndexcrush, 7
			Jae Go_got
			Jmp R_loop
		
		Checkcentrex_axis:					
			
			Cmp Culndexcrush, 3
			
			Jb R_loop
			
			Cmp Culndexcrush, 6
			
			Ja R_loop
			
			Jmp Go_got
		
		R_loop:
			Mov Bl, R_indexcrush
			Mov Al, Sumculs
			Mul Bl
			Mov Bx, Ax
			Call Vercrush		
			
		Go_got:	
			Inc R_indexcrush
			Cmp R_indexcrush, 10
			Jb Fullr_loop
		
		Inc Culndexcrush
		Cmp Culndexcrush, 10
		Jb Culloop
	
	Pop Dx;pop Dx To Stack
	Pop Si
	Pop Ax ;pop Ax To Stack
	Pop Bx
	
	Ret		
Vertraversal Endp

Vercrush Proc
	Mov Di, Bx
	Mov Dl, R_indexcrush
	Mov Var1var, Dl


	Cmp R_indexcrush, 8		
	Jb Checkcrush
	Jmp Exit

	Checkcrush:
		Push Bx
		Add Bx, Si
		Mov Startingindex, Bx
		Pop Bx

		Mov Al, Stagesarray[bx+si]		
		
		Cmp Al, '8'						
		
		Je Exit

		Cmp Al, 'x'
		Je Exit
		
		Add Bx, 10
		Cmp Al, Stagesarray[bx+si]
		Je Checkgo_nextvalue			
		Jmp Exit

	Checkgo_nextvalue:
		Add Bx, 10
		Cmp Al, Stagesarray[bx+si]


		Je Fillzero					
		Jmp Exit

	Fillzero:

		Mov Isvercrush, 1		

		Mov Combolength, 3
		Add Point, 3
		
		Go_got:
			Mov Bx, Di
			Mov Stagesarray[bx+si], 0
			Inc Var1var
			Add Bx, 10
			Mov Stagesarray[bx+si], 0
			Inc Var1var
			Add Bx, 10
			Mov Stagesarray[bx+si], 0

	Crushall:
		Inc Var1var
		Cmp Var1var, 10				; Checking If Bondaries Are Not Crossed
		Jb Checkabovethreecombo
		Jmp Endfn

	Checkabovethreecombo:
		Add Bx, 10
		Cmp Al, Stagesarray[bx+si]
		Je Makezero
		Jmp Endfn		
	
	Makezero:
		Inc Combolength
		Inc Point
		Mov Stagesarray[bx+si-10], 0		; Set Previous Index To 0
		Mov Stagesarray[bx+si], '8'		; Set Last Index Of Combo To '8' To Indicate Bomb
		Jmp Crushall 

	Endfn:
		Push Bx
		Add Bx, Si
		Sub Bx, 10
		Mov Endingindex, Bx	; Firstizing Var For Removeblockershorizontally
		Pop Bx
		
		Cmp Stagesno, 3
		Jne Exit
		Call Removeblockersverly
		
	Exit:
		Ret

Vercrush Endp	


Blast_bomb Proc

	
	Mov Si, 0
	Mov Cx, 100
	Bombloop:
		
		Cmp Al, Stagesarray[si]		
		
		Je Makezero
		
		Cmp Stagesarray[si], '8'	
		
		Je Makezero
		Jmp Checkgo_next		
	
	Makezero:
		Mov Stagesarray[si], 0
		
	Checkgo_next:
		Inc Si
		Loop Bombloop
	
	Mov Isbomb, 1
	Mov Bombno, Al 
	
	
	Ret
Blast_bomb Endp 


Dropnobers Proc
	Push Bx
	Push Ax	;push Ax To Stack
	Push Si
	Push Dx;push Dx To Stack
	
	Mov Ax, 0
	Mov Dx, 0
	
	Mov Dropr_, 0
	R_loop:
		
		Mov Dropcul, 0
		Culloop:
			
			Mov Bl, Dropr_
			Mov Al, Sumculs
			Mul Bl
			Mov Bx, Ax
			Mov Dx, 0
			Mov Dl, Dropcul
			Mov Si, Dx
			Cmp Stagesarray[bx+si], 0
			Je Callmoveup
			Jmp Checkgo_next
			
			Callmoveup:
				Call Moveup
			
			Checkgo_next:
				Inc Dropcul
				Cmp Dropcul, 10
				Jb Culloop
			
			Inc Dropr_
			Cmp Dropr_, 10
			Jb R_loop
	
	Pop Dx;pop Dx To Stack
	Pop Si
	Pop Ax ;pop Ax To Stack
	Pop Bx		
	Ret
Dropnobers Endp

 
Moveup Proc
	Mov Var1, 0
	
	Mov Dl, Dropr_
	
	Mov Var1r_, Dl
	
	Uploop:	
		Cmp Var1r_, 0		
		
		Je Getrandom
		
		Cmp Stagesarray[bx+si-10], 7		
		Je Getrandom
		
		Cmp Stagesarray[bx+si-10], 'x'	
		Je Checkifxisatgo_topr_
 
		Mov Dl, Stagesarray[bx+si]     
		
		Mov Dh, Stagesarray[bx+si-10]  
		
		Mov Stagesarray[bx+si], Dh		
		
		Mov Stagesarray[bx+si-10], Dl
		
		Dec Var1r_
		
	Keepmovingup:
		Mov Bx, 0
		Mov Ax, 0
		Mov Bl, Var1r_
		Mov Al, Sumculs
		Mul Bl
		Mov Bx, Ax
		
		Jmp Uploop
	
	Checkifxisatgo_topr_:
		Mov Dl, Var1r_
		Mov Var1, Dl
		Dec Var1		
		Cmp Var1, 0 					; If Blocker Is At Go_top Of Array, Sgo_top Moving Up
		Je Getrandom	
		Mov Dl, Stagesarray[bx+si]     	; Dl = 0 
		Mov Dh, Stagesarray[bx+si-20]  	; Dh  = Value In The Upper R_ And Skipping X
		Mov Stagesarray[bx+si], Dh		; Swapping Values
		Mov Stagesarray[bx+si-20], Dl
		Sub Var1r_, 2  					; Moving Two Spots Up
		Jmp Keepmovingup
	
	Getrandom:
		Mov Randomrange, 5
		Call Generaterandomomno
		Push Dx;push Dx To Stack
		Mov Dl, Randomno
		Mov Stagesarray[bx+si], Dl
		Pop Dx;pop Dx To Stack
		
	Ret
Moveup Endp

;----------------------------------------------------------------------------------------------------------------------------------------

Perpetualcrushing Proc
	
	Go_gotinuouscrush:
		Call Horizontaltraversal	
		Call Vertraversal
		
		Cmp Ishorizontalcrush, 1	; Check If Horizontal Crush Occured
		Je Crushagain
		
		
		Cmp Isvercrush, 1		; Check If Ver Crush Occured
		
		Je Crushagain
		
		Jmp Finish					; If No Crushing Occured, Then Exit
		
		
		
		Crushagain:
		
		Mov Showboxclr, 9		

			Call Printjeeinfo

			Call Showstages				; Show Stages To Show Removed Combinations Which Show Up As Blank Blocks

			

			Call Dropnobers			; Replace Blank Blocks With New Nobers

			Call Showstages				; Show Array To Show Changes

		

			Mov Ishorizontalcrush, 0


			Mov Isvercrush, 0


			Jmp Go_gotinuouscrush			; Check For Combinations Again


		Finish:
			Mov Showboxclr, 9		
			Call Printjeeinfo
			Call Showstages	
			Ret	
Perpetualcrushing Endp



Removeblockershorizontally Proc	
	Mov Ax, Startingindex
	Mov Bh, 10
	Div Bh				
	Cmp Ah, 0			
	Jne Startmiddle		
	
		
		Mov Si, Startingindex
		Cmp Si, 9
		Jna Infirstr__first	; If In First R_, Only Check The Block Below
		
		Cmp Si, 90				; If In Last R_, Only Check The Block Above, Else Check Both Above And Below
		Jae Inlastr__first
		Call Checkabove
		Call Checkbelow
		Jmp Middleblocks_first
		
		Infirstr__first:		
			Call Checkbelow
			Jmp Middleblocks_first
			
		Inlastr__first:
			Call Checkabove
		
		Middleblocks_first:	; Checking Middle Blocks Of Combination, Excluding First And Last Blocks
		Xor Cx, Cx
		Mov Cl, Combolength 
		Sub Cl, 2
		Inc Si
		
		Checkblockerloop_first:
			Cmp Startingindex, 9	; Don't Check Above If Its The First R_
			Jna Onlybelow_first
			
			Cmp Si, 90
			Jae Onlyabove_first
			Call Checkabove
			Call Checkbelow
			Jmp Go_nextloopiter_first
			
			Onlyabove_first:
				Call Checkabove
				Jmp Go_nextloopiter_first
			
			Onlybelow_first:			; Not First R_, Need To Check Above And Below Of The Block
				Call Checkbelow
				

			Go_nextloopiter_first:

			Inc Si

			Loop Checkblockerloop_first
		
		Jmp Checklastblock
	Startmiddle:

		Mov Si, Startingindex

		Cmp Si, 9

		Jna Infirstr__middle	

		Cmp Si, 90			

		Jae Inlastr__middle

		Call Checkabove

		Call Checkbelow


		Call Checkgo_left

		Jmp Middleblocks_middle
		
		Infirstr__middle:		
			Call Checkbelow
			Call Checkgo_left
			Jmp Middleblocks_middle
			
		Inlastr__middle:
			Call Checkabove
			Call Checkgo_left
			
		Middleblocks_middle:	; Checking Middle Blocks Of Combination, Excluding First And Last Blocks
		Xor Cx, Cx
		Mov Cl, Combolength
		Sub Cl, 2
		Inc Si
		
		Checkblockerloop_middle:
			Cmp Startingindex, 9	; Don't Check Above If Its The First R_
			
			
			Jna Onlybelow_middle
			
			Cmp Si, 90
			Jae Onlyabove_middle
			Call Checkabove
			Call Checkbelow
			Call Checkgo_left
			Jmp Go_nextloopiter_middle
			
			Onlyabove_middle:
				Call Checkabove
				Call Checkgo_left
				Jmp Go_nextloopiter_middle
			
			Onlybelow_middle:	
				Call Checkbelow
				Call Checkgo_left
				
			Go_nextloopiter_middle:
			Inc Si
			Loop Checkblockerloop_middle
			
	Checklastblock:
		Mov Si, Endingindex
		Call Getlastculndex
		Xor Dx, Dx
		Mov Dl, Lastculndex	; Lastculndex Go_gotains The Index Of The Last Culumn In Which Combo Was Made
		
		Cmp Si, 9
		Jna	Infirstr__last
		
		Cmp Si, 90
		Jae Inlastr__last
		
		Cmp Endingindex, Dx
		Je Inlastculc
		
		Call Checkabove
		Call Checkbelow
		Call Checkright
		Ret
		
		Inlastculc:
			Call Checkabove
			Call Checkbelow
			Ret
	
		Infirstr__last:
			Cmp Endingindex, Dx
			Je Inlastcula
			
			Call Checkbelow
			Call Checkright
			Ret
			
			Inlastcula:
				Call Checkbelow
				Ret
		
		Inlastr__last:
			Cmp Endingindex, Dx
			Je Inlastculb
			
			Call Checkabove
			Call Checkright
			Ret
			
		Inlastculb:
			Call Checkabove
				
	Ret	
Removeblockershorizontally Endp

Checkbelow Proc
	Cmp Stagesarray[si + 10], 'x'
	Jne Exit
	Mov Stagesarray[si + 10], 0

	Exit:
		Ret
Checkbelow Endp

Checkabove Proc
	Cmp Stagesarray[si - 10], 'x'
	Jne Exit
	Mov Stagesarray[si - 10], 0

	Exit:
		Ret
Checkabove Endp

Checkgo_left Proc
	Cmp Stagesarray[si - 1], 'x'
	Jne Exit
	Mov Stagesarray[si - 1], 0

	Exit:
		Ret
Checkgo_left Endp

Checkright Proc
	Cmp Stagesarray[si + 1], 'x'
	Jne Exit
	Mov Stagesarray[si + 1], 0

	Exit:
		Ret
Checkright Endp

Getlastculndex Proc
	Push Ax	;push Ax To Stack
	Push Bx

	Mov Ax, Si
	Mov Bh, 10
	Div Bh
	
	Mov Ah, 0
	Mul Bh
	Add Al, 9
	
	Mov Lastculndex, Al
	
	Pop Bx
	Pop Ax ;pop Ax To Stack
	Ret
Getlastculndex Endp

Removeblockersverly Proc	
	Cmp Startingindex, 9	
	Ja Startmiddle			
		Mov Si, Startingindex
		Cmp Si, 0
		
		Je Infirstcul_first		
		
		Cmp Si, 9				
		
		Je Inlastcul_first
		Call Checkright
		Call Checkgo_left
		Jmp Middleblocks_first
		
		Infirstcul_first:		
			Call Checkright
			Jmp Middleblocks_first
			
		Inlastcul_first:
			Call Checkgo_left
		
		Middleblocks_first:	
		
		Xor Cx, Cx
		
		Mov Cl, Combolength 
		Sub Cl, 2
		Add Si, 10
		
		Checkblockerloop_first:
			Cmp Startingindex, 0
			Je Onlyright_first
			Cmp Si, 9
			Je Onlygo_left_first
			Call Checkright
			Call Checkgo_left
			Jmp Go_nextloopiter_first
			
			Onlygo_left_first:
				Call Checkgo_left
				Jmp Go_nextloopiter_first
			
			Onlyright_first:			
				Call Checkright
				
			Go_nextloopiter_first:
			Add Si, 10
			Loop Checkblockerloop_first
		
		Jmp Checklastblock
	
	Startmiddle:
		Mov Si, Startingindex
		Mov Ax, Si				
		Mov Bh, 10
		Div Bh
		Cmp Ah, 0
		
		Je Infirstcul_middle	\
		
		Call Getlastculndex
		
		Xor Dx, Dx
		
		Mov Dl, Lastculndex	
		Cmp Si, Dx				
		Je Inlastcul_middle		
		
		Call Checkabove			
		Call Checkright
		Call Checkgo_left
		Jmp Middleblocks_middle
		
		Infirstcul_middle:		
			Call Checkabove
			Call Checkright
			Jmp Middleblocks_middle
			
		Inlastcul_middle:
			Call Checkabove
			Call Checkgo_left
			
		Middleblocks_middle:	
		Xor Cx, Cx
		Mov Cl, Combolength
		Sub Cl, 2
		Add Si, 10
		
		Checkblockerloop_middle:
			Mov Ax, Startingindex					
			Mov Bh, 10
			Div Bh
			Cmp Ah, 0			
			Je Checkright_middle				
			Call Getlastculndex
			Xor Dx, Dx
			Mov Dl, Lastculndex	
			Cmp Si, Dx			
			Je Checkgo_left_middle		
			
			Call Checkgo_left
			Call Checkright
			Jmp Go_nextloopiter_middle
			
			Checkgo_left_middle:
				Call Checkgo_left
				Jmp Go_nextloopiter_middle
			
			Checkright_middle:			; Not First R_, Need To Check Above And Below Of The Block
				Call Checkright
				
			Go_nextloopiter_middle:
			Add Si, 10
			Loop Checkblockerloop_middle
			
	Checklastblock:
		Mov Si, Endingindex
		Mov Ax, Si				
		Mov Bh, 10
		Div Bh
		Cmp Ah, 0
		Je Infirstcul_last			
		Call Getlastculndex
		
		Xor Dx, Dx
		
		Mov Dl, Lastculndex	
		
		Cmp Si, Dx			
		
		Je Inlastcul_last	
		
		Cmp Si, 90
		Ja Inmiddlecullastr_
		Call Checkbelow		
		Call Checkright
		Call Checkgo_left
		Ret
		
		Inmiddlecullastr_:
			Call Checkright
			Call Checkgo_left
			Ret
		
		Infirstcul_last:
			Cmp Si, 90
			Je Blockno90
			Call Checkright
			Call Checkbelow
			Ret
			
			Blockno90:
				Call Checkright
				Ret
		
		Inlastcul_last:
			Cmp Si, 99
			Je Blockno99
			Call Checkgo_left
			Call Checkbelow
			Ret
			
			Blockno99:
				Call Checkgo_left
				
	Ret	
Removeblockersverly Endp

Diplaymultidigitnober Proc
	Push Dx;push Dx To Stack
	Push Cx;push Cx To Stack
	Mov Printnocount, 0 
	Mov Bl, 10
	
	Pushingnoberintostack:

		Div Bl

		Mov Remain, Ah

		Mov Quotient, Al


		Mov Ah, 0
		Mov Al, Remain


		Push Ax	;push Ax To Stack					

		Inc Printnocount

		Mov Al, Quotient		

		Mov Ah, 0
		Cmp Al, 0		
		
		Jne Pushingnoberintostack ;pushingnumbers In Stack
		
		Mov Dh, Printnor_
		
		Mov Dl, Printnocul
		
		
		Popingandshowingnober:
		
		Pop Ax ;pop Ax To Stack
		
		Mov Remain, Al 
		
		
		Add Remain, 48
		
		Mov Ah, 02 ;print			;moving Cursor To The Position Where Char Should Be Printed
		
		Int 10h ; Intrept
		
		
		Mov Ah, 09
		Mov Al, Remain
		Mov Bl, Printnoculor
		Mov Cx, 1
		Mov Bh, 0
		Int 10h ; Intrept
		
		Inc Dl					;inc Culumn
		Dec Printnocount
		Cmp Printnocount, 0
		Ja Popingandshowingnober
	
	Pop Cx;pop Cx To Stack
	Pop Dx;pop Dx To Stack
	Ret
Diplaymultidigitnober Endp	

	
Printfirstwindow Proc;start Window
	Push Ax	;push Ax To Stack
	
	Mov Ah, 0		; Set Video Mode 640x480
	Mov Al, 12h
	Int 10h ; Intrept
	
	Call Printnoberborder;print The Number Border
	Call Showboxborder
	Call Printentername
	Call Storeplayername 
	
	Pop Ax ;pop Ax To Stack
	Ret
Printfirstwindow Endp

;printing Numbers Border
Printnoberborder Proc
	Push Ax	;push Ax To Stack
	Push Bx
	Push Cx;push Cx To Stack
	Push Dx;push Dx To Stack
	Push Si

	Mov Dh, 0
	Mov Cx, 7
	Go_top:
		Push Cx;push Cx To Stack
		Call Disp_rand_horiz		
		Inc Dh
		Pop Cx;pop Cx To Stack
		Loop Go_top
		
	Mov Dh, 23
	Mov Cx, 7
	Down:
		Push Cx;push Cx To Stack
		Call Disp_rand_horiz		
		Inc Dh
		Pop Cx;pop Cx To Stack
		Loop Down	
	
	Mov Dl, 0
	Mov Cx, 5
	Go_left:
		Push Cx;push Cx To Stack
		Call Disp_ran_vert
		Inc Dl
		Pop Cx;pop Cx To Stack
		Loop Go_left
	
	Mov Dl, 75
	Mov Cx, 5
	Right:
		Push Cx;push Cx To Stack
		Call Disp_ran_vert
		Inc Dl
		Pop Cx;pop Cx To Stack
		Loop Right
	
	Pop Si
	Pop Dx;pop Dx To Stack
	Pop Cx;pop Cx To Stack
	Pop Bx
	Pop Ax ;pop Ax To Stack	
	Ret
Printnoberborder Endp


Printendwindow Proc
	Push Ax	;push Ax To Stack
	Mov Ah, 0		
	Mov Al, 12h
	Int 10h ; Intrept
	
	Call Printnoberborder;print The Number Border
	Call Showboxborder
	
	Mov Showstrcul, 27			
	Mov Showstrr_, 13
	Mov Showstrculor, 0eh
	Lea Si, Greetyoumsg
	Call Showstring 
	
	Mov Showstrr_, 14			; "Your Final Point Is"
	Mov Showstrcul, 26
	Mov Showstrculor, 0eh
	Lea Si, Point_endmsg
	Call Showstring
	
	Mov Printnocul, 46		; Printthe Point
	Mov Printnor_, 14
	Mov Printnoculor, 0eh
	Add Ax, Point
	Mov Ax, Sumpoint
	
	Call Diplaymultidigitnober
	Jmp Exitmain
	
	Pop Ax ;pop Ax To Stack
	Ret
Printendwindow Endp





Storeplayername  Proc ;stores Player Name 
	Push Ax	;push Ax To Stack
	Push Dx;push Dx To Stack
	
	Mov Dl, 30
	Mov Dh, 13
	Mov Ah, 02 ;print
	Int 10h ; Intrept
		

	Lea Si, Playername

	Mov Ah, 01h


	Inchar:

		Int 21h

		Mov [si], Al

		Inc Si

		Cmp Al, 13

		Jne Inchar

			
	Pop Dx;pop Dx To Stack
	Pop Ax ;pop Ax To Stack
	Ret	

Storeplayername  Endp

;prints The Message Enter Yout Name In Display
Printentername Proc
	Push Dx;push Dx To Stack
	Push Ax	;push Ax To Stack
	Push Si
	Push Cx;push Cx To Stack
	Push Bx
	
	Mov Dh, 13
	Mov Dl, 13
	Mov Si, 0
	
	Showingentername:
		Mov Ah, 02 ;print
	
		Int 10h ; Intrept
		
		Mov Ah, 09 ;string Print
		
		Mov Al, Enternamemsg[si]
		
		Mov Bl, 0eh
		
		Mov Cx, 1
		
		Mov Bh, 0
		
		Int 10h ; Intrept	
		
		Inc Dl
		Inc Si
		Cmp Enternamemsg[si], "$"
		Jne Showingentername 	
	
	Pop Bx
	Pop Cx;pop Cx To Stack
	Pop Si
	Pop Ax ;pop Ax To Stack
	Pop Dx;pop Dx To Stack
	
	Ret
Printentername Endp

;----------------------------------------------------------------------------------------------------------------------------------------
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;| Printplayername |;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;----------------------------------------------------------------------------------------------------------------------------------------


;print Players Name
Printplayername Proc
	Push Dx;push Dx To Stack
	Push Ax	;push Ax To Stack
	Push Si
	Push Cx;push Cx To Stack
	Push Bx
	
	Mov Dh, 0
	Mov Dl, 6
	Mov Si, 0
	
	Showingname:
		Mov Ah, 02 ;print
		
		Int 10h ; Intrept
		
		Mov Ah, 09 ;string Print
		
		Mov Al, Playername[si]
		
		Mov Bl, 0ch
		
		Mov Cx, 1
		
		Mov Bh, 0
		
		Int 10h ; Intrept	
		
		
		Inc Dl
		
		Inc Si
		
		Cmp Playername[si], 13
		
		Jne Showingname 	
	
	Pop Bx
	Pop Cx;pop Cx To Stack
	Pop Si
	Pop Ax ;pop Ax To Stack
	Pop Dx;pop Dx To Stack
	
	Ret
Printplayername Endp

;----------------------------------------------------------------------------------------------------------------------------------------
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;| Disp_rand_horiz |;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;----------------------------------------------------------------------------------------------------------------------------------------

Disp_rand_horiz Proc

;shows A Random Horzantal Line 	
	Push Dx;push Dx To Stack

	
	Mov Cx, 80
	
	Mov Dl, 0			
	
	Print:
	
	Mov Ah, 02 ;printh		  

	Int 10h ; Intrept
		
	
		Mov Al, '$'   	   
			 	
		Mov Bh, 0		
	
	Mov Bl, Cl	     	

	Push Cx;push Cx To Stack
	
	
	Mov Cx, 1		  		
	Mov Ah, 9h				
	Int 10h ; Intrept    
	Pop Cx;pop Cx To Stack
	Inc Dl
	Loop Print
		
	Pop Dx;pop Dx To Stack	
	Ret	
Disp_rand_horiz Endp


Disp_ran_vert Proc ;verical Random Number Line 
	Push Dx;push Dx To Stack
	
	Mov Cx, 16
	
	Mov Dh, 7			
	
	Print:
	
	Mov Ah, 02 ;printh		
	
	Int 10h ; Intrept
		
	
 	Mov Al, '$'   	  
			 	
	Mov Bh, 0		 	 
	Mov Bl, Cl	     	
	
	Push Cx;push Cx To Stack
	
	Mov Cx, 1		  		
	
	Mov Ah, 9h			
	
	Int 10h ; Intrept    
			Pop Cx;pop Cx To Stack
		
			Inc Dh
		
			Loop Print
		
	Pop Dx;pop Dx To Stack	
	
		Ret	
Disp_ran_vert Endp




Showboxborder Proc ; Display The Border On Win Start Screen
	Push Bx
	Push Dx;push Dx To Stack
	Push Cx;push Cx To Stack
	
	Mov Bx, 0
	Mov Cx, 42
	Mov Dx, 112
	Go_topline:
		Mov Ah, 0ch
		Mov Al, 0eh
		Push Bx
		Mov Bh, 0
		Int 10h ; Intrept
		Pop Bx
		
		Inc Cx
		Inc Bx
		Cmp Bx, 555
		Jb Go_topline

	Mov Bx, 0
	Mov Cx, 42
	Mov Dx, 366
	Downline:
		Mov Ah, 0ch
		Mov Al, 0eh
		Push Bx
		Mov Bh, 0
		Int 10h ; Intrept
		Pop Bx
		
		Inc Cx
		Inc Bx
		Cmp Bx, 555
		Jb Downline	
	
	Mov Bx, 0
	Mov Cx, 597
	Mov Dx, 112
	Rline:
		Mov Ah, 0ch
		Mov Al, 0eh
		Push Bx
		Mov Bh, 0
		Int 10h ; Intrept
		Pop Bx
		
		Inc Dx
		Inc Bx
		Cmp Bx, 255
		Jb Rline	
		
	Mov Bx, 0
	Mov Cx, 42
	Mov Dx, 112
	L_line:
		Mov Ah, 0ch
		Mov Al, 0eh
		Push Bx
		Mov Bh, 0
		Int 10h ; Intrept
		Pop Bx
		
		Inc Dx
		Inc Bx
		Cmp Bx, 255
		Jb L_line	
		
	Pop Cx;pop Cx To Stack
	Pop Dx;pop Dx To Stack
	Pop Bx
	Ret
Showboxborder Endp

End
