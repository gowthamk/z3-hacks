;; (set-option :auto-config false)
;; (set-option :smt.mbqi true)
;; (set-option :smt.macro-finder true)
(declare-sort Eff)
(declare-fun isWithdraw (Eff) Bool)
(declare-fun isDeposit (Eff) Bool)
;; type of effects
(assert (forall ((e Eff))
    (or (isWithdraw e) (isDeposit e))))
;; effAmt returns the PosInt tagged with W or D
(declare-fun effAmt (Eff) Int)
(assert (forall ((e Eff)) (>= (effAmt e) 0)))
;; vis is an irreflexive binary relation on effects
(declare-fun vis (Eff Eff) Bool)
(assert (forall ((e Eff)) (not (vis e e))))
;; Let EffList type stand for list of effects
(declare-sort EffList)
;; getBalance is a function from EffList to Int
(declare-fun getBalance (EffList) Int)
;; Rmem relates an EffList to Effects it contains.
;; Informally, we write Rmem(l) to denote the set of effects in
;; EffList l.
(declare-fun Rmem (EffList Eff) Bool)
;; Let n stand for the current withdraw effect
(declare-const n Eff)
(assert (isWithdraw n))
;; ctxtW is the context (visibility set), when n was produced
(declare-const ctxtW EffList)
(assert (forall ((e Eff)) (= (vis e n) (Rmem ctxtW e))))
;; The path condition when n was emitted asserts:
(assert (>= (getBalance ctxtW) (effAmt n)))
;; ctxtGB is the context for getBalance function:
(declare-const ctxtGB EffList)

;; Here is the parition theorem:
;; Let ctxt be the context for an operation. Then, there always exists
;; a ctxt', such that Rmem(ctxt') = Rmem(ctxt), and forall (e',e \in
;; Rmem(ctxt')) such that hbo(e',e), (e',e) \in Robs(ctxt).
;; Proof follows from irreflexivity of hbo.
;; The theorem simply states that a context of an operation can always
;; be rearranged in such a way that if effect e' happened-before effect
;; e, then e' occurs before e in the context.
;; We make use of this theorem in our analysis and assume that any
;; context (e.g: ctxtGB) honours hbo.

;; Let ctxtGB1 be the prefix of ctxtGB preceeding the effect n.
(declare-const ctxtGB1 EffList)
(assert (not (Rmem ctxtGB1 n)))
;; Rmem(ctxtGB1) \subseteq Rmem(ctxtGB)
(assert (forall ((e Eff)) (=> (Rmem ctxtGB1 e) (Rmem ctxtGB e))))
;; Forall effects e \in Rmem(ctxtGB) that are visible to n,
;; e \in Rmem(ctxtGB1)
(assert (forall ((e Eff)) (=> (and (vis e n) (Rmem ctxtGB e)) 
                              (Rmem ctxtGB1 e))))
;; Forall effects e \in Rmem(ctxtGB) to which n is visible,
;; e \notin Rmem(ctxtGB1)
(assert (forall ((e Eff)) (=> (and (vis n e) (Rmem ctxtGB e)) 
                              (not (Rmem ctxtGB1 e)))))

;; Instantiate getBalance contract:
(assert (forall ((e Eff)) (=> (and (isDeposit e) (vis e n))
                      (Rmem ctxtGB e))))
;; Instantiate withdraw contract
(assert (forall ((e Eff)) (=> (isWithdraw e)
                      (or (= e n) (vis e n) (vis n e)))))
;; Following two theorems are now valid:
;; Thm1: There cannot be a withdraw effect in ctxtGB1 that is not
;; present in ctxtW.
(push)
(assert (not (forall ((e Eff)) 
    (=> (and (isWithdraw e) (Rmem ctxtGB1 e))
        (Rmem ctxtW e)))))
(check-sat)
(pop)
;; Thm2: There cannot be a deposit effect in ctxtW that is not present
;; in ctxtGB1.
(push)
(assert (not (forall ((e Eff)) 
    (=> (and (isDeposit e) (Rmem ctxtW e))
        (Rmem ctxtGB1 e)))))
(check-sat)
(pop)
;; Axiomatize getBalance definition:
(assert (forall ((l EffList)) 
    (=> (forall ((x Eff)) (= (Rmem l x) false))
        (= (getBalance l) 0))))
(assert (forall ((e Eff) (l1 EffList) (l2 EffList)) 
    (=> (and (not (Rmem l2 e)) 
             (forall ((x Eff)) (= (Rmem l1 x) (or (= x e) (Rmem l2 x))))
             (isWithdraw e))
        (= (getBalance l1) (- (getBalance l2) (effAmt e))) )))
(assert (forall ((e Eff) (l1 EffList) (l2 EffList)) 
    (=> (and (not (Rmem l2 e)) 
             (forall ((x Eff)) (= (Rmem l1 x) (or (= x e) (Rmem l2 x))))
             (isDeposit e))
        (= (getBalance l1) (+ (getBalance l2) (effAmt e))) )))
;; We now go for the kill. 
(assert (< (getBalance ctxtGB1) (effAmt n)))
(check-sat)




