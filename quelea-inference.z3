;; Command to run: 
;; z3 -smt2 smt.mbqi=true smt.macro-finder=true -T:20 quelea-inference.z3
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
(declare-const d0 Eff)
(declare-const d1 Eff)
(declare-const w0 Eff)
(declare-const w1 Eff)
(declare-const gb Eff)
;; Cardinality constraint
(assert (forall ((e Eff)) (or (= e d0) (= e d1) (= e w0) 
                              (= e w1) (= e gb))))
;; Session-order among effects
;(assert (and (so d0 d1) (so d1 w0) (so w0 w1) (so w1 gb)))
;; Amounts
(declare-const x0 Int)
(declare-const x1 Int)
(declare-const y0 Int)
(declare-const y1 Int)
;; Amounts are positive
(assert (and (> x0 0) (> y0 0) (> x1 0) (> y1 0)))
;; amt function associates effects with amount
(define-fun amt ((e Eff)) Int
  (if (= e d0) x0
      (if (= e d1) x1
           (if (= e w0) y0
               (if (= e w1) y1 0)))))
;; 
(define-fun sel ((a Eff)(n Eff)) Int
  (if (vis a n) (amt a) 0))
;; bal0 is balance when w0 is produced
(declare-const bal0 Int)
(assert (= bal0 (- (+ (sel d0 w0) (sel d1 w0)) (sel w1 w0))))
;; Since w0 was produced, bal0 ≥ y0
(assert (>= bal0 y0))
;; bal1 is balance when w1 is produced
(declare-const bal1 Int)
(assert (= bal1 (- (+ (sel d0 w1) (sel d1 w1)) (sel w0 w1))))
;; Since w1 was produced, bal1 ≥ y0
(assert (>= bal1 y1))
;; v is the result of the getBalance operation
(declare-const v Int)
(assert (= v (- (- (+ (sel d0 gb) (sel d1 gb)) (sel w0 gb)) (sel w1 gb))))
;; Check satisfiability of negation to derive an anomaly
;(assert (< v 0))
(check-sat)
(get-model)
(echo "Vis for gb")
(eval (vis d0 gb))
(eval (vis d1 gb))
(eval (vis w0 gb))
(eval (vis w1 gb))
(echo "Vis for w1")
(eval (vis d0 w1))
(eval (vis d1 w1))
(eval (vis w0 w1))
(eval (vis gb w1))
(echo "Vis for w0")
(eval (vis d0 w0))
(eval (vis d1 w0))
(eval (vis w1 w0))
(eval (vis gb w0))
(echo "Vis for d0")
(eval (vis d1 d0))
(eval (vis w0 d0))
(eval (vis w1 d0))
(eval (vis gb d0))
(echo "Vis for d1")
(eval (vis d0 d1))
(eval (vis w0 d1))
(eval (vis w1 d1))
(eval (vis gb d1))
(echo "SO for gb")
(eval (so d0 gb))
(eval (so d1 gb))
(eval (so w0 gb))
(eval (so w1 gb))
(echo "SO for w1")
(eval (so d0 w1))
(eval (so d1 w1))
(eval (so w0 w1))
(eval (so gb w1))
(echo "SO for w0")
(eval (so d0 w0))
(eval (so d1 w0))
(eval (so w1 w0))
(eval (so gb w0))
(echo "SO for d0")
(eval (so d1 d0))
(eval (so w0 d0))
(eval (so w1 d0))
(eval (so gb d0))
(echo "SO for d1")
(eval (so d0 d1))
(eval (so w0 d1))
(eval (so w1 d1))
(eval (so gb d1))
(echo "x0=")
(eval x0)
(echo "x1=")
(eval x1)
(echo "y0=")
(eval y0)
(echo "y1=")
(eval y1)
(echo "v=")
(eval v)

