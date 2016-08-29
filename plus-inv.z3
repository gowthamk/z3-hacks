; fun slowPlus x y = 
;   if (x<0) then x+y
;   else if (x=0) then y
;   else 1 + slowPlus (x-1) y

; c \in Z
; e ::= k | c*x | e + e 
; \phi ::= x=e | x<e | x<=e | x>e | x>=e | \phi /\ \phi 

; We can't do much with linear integer arithmetic. 

(declare-const x Int)
(declare-const y Int)
(declare-const z Int)
;; let return type be {z | z = cx+e}
(assert (=> (< x 0) (= z (+ x y))))

