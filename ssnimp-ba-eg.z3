;; Command to run: 
;; z3 -smt2 smt.mbqi=true smt.macro-finder=true -T:20 ssnimp-ba-eg.z3
(declare-datatypes () ((Oper GB WD DP NOP)))
(declare-datatypes () ((Eff e1 e2 e3 e4 e5)))
(declare-fun oper (Eff) Oper)
(declare-fun rval (Eff) Int)
; rval of deposits and withdraws is always non-negative
(assert (forall ((e Eff)) (=> (or (= (oper e) DP) (= (oper e) WD)) 
                              (>= (rval e) 0))))

;; ---- VISIBILITY ----
(declare-fun vis (Eff Eff) Bool)
;; vis is irreflexive
(assert (forall ((e Eff)) (not (vis e e))))

;; a1 and a2 are non-negative constants.
(declare-const a1 Int)
(declare-const a2 Int)
(assert (>= a1 0))
(assert (>= a2 0))
;; sel is the guarded value of rval per effect
(define-fun sel ((a Eff)(n Eff)) Int
  (if (and (vis a n) (= (oper a) DP)) (rval a) 
    (if (and (vis a n) (= (oper a) WD)) (- 0 (rval a)) 0)))
;; getBalance defined per effect
(define-fun getBalance ((n Eff)) Int
  (+ (sel e1 n) (sel e2 n) (sel e3 n) (sel e4 n) (sel e5 n)))
;; e3 is GB
(assert (= (oper e3) GB))
(assert (= (rval e3) (getBalance e3)))
;; e4 may be WD or NOP
(assert 
  (if (>= (getBalance e4) a1) 
    (and (= (oper e4) WD) (= (rval e4) a1)) 
    (and (= (oper e4) NOP))))
;; e5 may be WD or NOP
(assert 
  (if (>= (getBalance e5) a2) 
    (and (= (oper e5) WD) (= (rval e5) a2)) 
    (and (= (oper e5) NOP))))
(assert (>= (+ (sel e1 e3) (sel e2 e3)) 0))

;; The high-level invariant
(declare-const inv Bool)
(assert (= inv (>= (rval e3) 0)))

;; Initial run - no more constraints
(push)
(assert (not inv))
(check-sat)    
(get-model)
(pop)

;; 1st Counterexample
(push)
;; First assert general details about effect labels.
;; e1 is DP, e2 is GB, e4 is WD, and e5 is NOP.
(assert (= (oper e1) DP))
(assert (= (oper e2) GB))
(assert (= (oper e4) WD))
(assert (= (oper e5) NOP))

;; assert soft constraints
(assert-soft (not (vis e1 e2)))
(assert-soft (not (vis e1 e3)))
(assert-soft (not (vis e1 e4)))
(assert-soft (not (vis e1 e5)))
(assert-soft (not (vis e2 e1)))
(assert-soft (not (vis e2 e3)))
(assert-soft (not (vis e2 e4)))
(assert-soft (not (vis e2 e5)))
(assert-soft (not (vis e3 e1)))
(assert-soft (not (vis e3 e2)))
(assert-soft (not (vis e3 e4)))
(assert-soft (not (vis e3 e5)))
(assert-soft (not (vis e4 e1)))
(assert-soft (not (vis e4 e2)))
(assert-soft (not (vis e4 e3)))
(assert-soft (not (vis e4 e5)))
(assert-soft (not (vis e5 e1)))
(assert-soft (not (vis e5 e2)))
(assert-soft (not (vis e5 e3)))
(assert-soft (not (vis e5 e4)))

(push)
;; Then assert specific details.
;; a1 = 1 and a2 = 1
(assert (and (= a1 1) (= a2 1)))
;; vis(e1,e4) /\ vis(e4,e3)
(assert (and (vis e1 e4) (vis e4 e3)))
(assert inv)
(check-sat)    
(get-model)
;; The solution returned is vis(e1,e3)
(pop)

;; Now, check if the solution is sufficient
(push)
(assert (=> (and (vis e1 e4) (vis e4 e3)) (vis e1 e3)))
(assert (not inv))
(check-sat) ; Unsat! Hence, the solution is sufficient.
(get-model)
(pop)

(pop)
;; End of counterexample 1


