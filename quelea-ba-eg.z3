;; Command to run: 
;; z3 -smt2 smt.mbqi=true smt.macro-finder=true -T:20 quelea-ba-eg.z3
(declare-sort Eff)
(declare-fun vis (Eff Eff) Bool)
(declare-fun so (Eff Eff) Bool)
(declare-fun hb (Eff Eff) Bool)
;; ---- AXIOMS ----
;; vis is irreflexive
(assert (forall ((e Eff)) (not (vis e e))))
;; so is irreflexive
(assert (forall ((e Eff)) (not (so e e))))
;; so is transitive
(assert (forall ((a Eff)(b Eff)(c Eff))
  (=> (and (so a b) (so b c)) (so a c))))
;; hb is transitive closure of vis and so
(assert (forall ((a Eff)(b Eff))
  (=> (hb a b) (or (vis a b) (so a b)))))
(assert (forall ((a Eff)(b Eff)(c Eff))
  (=> (and (hb a b) (hb b c)) (hb a c))))
;; hb is irreflexive
(assert (forall ((e Eff)) (not (hb e e))))

;; Define effects
(declare-const d10 Eff)
(declare-const w4 Eff)
(declare-const w3 Eff)
(declare-const gb Eff)
;; Cardinality constraint
(assert (forall ((e Eff)) (or (= e d10) (= e w4) (= e w3) (= e gb))))
;; Session-order among effects
(assert (and  (so d10 w4) (so w4 w3) (so w3 gb)))
;; amt function associates effects with amount
(define-fun amt ((e Eff)) Int
  (if (= e d10) 10
      (if (= e w4) 4
          (if (= e w3) 3 0))))
;; sel is the guarded value of balance per effect
(define-fun sel ((a Eff)(n Eff)) Int
  (if (vis a n) (amt a) 0))
;; getBalance definition
(define-fun getBalance ((n Eff)) Int
  (- (sel d10 n) (sel w4 n) (sel w3 n)))
;; Since w4 was produced:
(assert (>= (getBalance w4) 4))
;; Since w3 was produced:
(assert (>= (getBalance w3) 3))
;; v is the result of the getBalance operation
(declare-const v Int)
(assert (= v (getBalance gb)))
;; Check satisfiability of negation to derive an anomaly
; (assert (not (= v 3)))
;; Check satisfiability of assertion to derive passing runs
(assert (= v 3))
(declare-const m Bool)
(declare-const n Bool)
(declare-const o Bool)
(declare-const p Bool)
(declare-const q Bool)
(declare-const r Bool)
(assert (= m (vis d10 w4)))
(assert (= n (vis d10 w3)))
(assert (= o (vis d10 gb)))
(assert (= p (vis w4 w3)))
(assert (= q (vis w4 gb)))
(assert (= r (vis w3 gb)))
;; CEGAR - negate aleady negative runs
; (assert (not (and m n (not o) (not p) q r)))
; (assert (not (and m n (not o) (not p) (not q) r)))
; (assert (not (and m n (not o) (not p) (not q) (not r))))
; (assert (not (and m n (not o)  p (not q) (not r))))
; (assert (not (and m n o (not p) (not q) (not r))))
; (assert (not (and m n o p (not q) (not r))))
; (assert (not (and m n (not o)  p (not q) r)))
; (assert (not (and m n (not o) (not p) q (not r))))
; (assert (not (and m n (not o) p q (not r))))
; (assert (not (and m n o (not p) q (not r))))
; (assert (not (and m n o p q (not r))))
; (assert (not (and m n (not o) p q r)))
; (assert (not (and m n o (not p) (not q) r)))
; (assert (not (and m n o p (not q) r))) 
;; All the above after logic gate minimization: mn~o + mn~q + mn~r
;; CEGAR - negate aleady seen +ve runs
(assert (not (and m n o p q r)))
(assert (not (and m n o (not p) q r)))
(check-sat)
;(get-model)
;(echo "Vis for gb")
(eval m)
(eval n)
(eval o)
(eval p)
(eval q)
(eval r)
;(echo "Vis for w3")
;(echo "Vis for w4")
; (echo "Vis for d10")
; (eval (vis w4 d10))
; (eval (vis w3 d10))
; (eval (vis gb d10))
; (echo "SO for gb")
; (eval (so d10 gb))
; (eval (so w4 gb))
; (eval (so w3 gb))
; (echo "SO for w3")
; (eval (so d10 w3))
; (eval (so w4 w3))
; (eval (so gb w3))
; (echo "SO for w4")
; (eval (so d10 w4))
; (eval (so w3 w4))
; (eval (so gb w4))
; (echo "SO for d10")
; (eval (so w4 d10))
; (eval (so w3 d10))
; (eval (so gb d10))
(echo "v=")
(eval v)

