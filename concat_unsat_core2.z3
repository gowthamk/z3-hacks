; Correct implementation of concat, being checked against the
; following incorrect spec: Robs(l) = Robs(l1) U Robs(l2)
; Produced following model:
; l1 = [x]; l2=[c0]; 
; We now make use of the unsatisfiability of the spec for this model
; to produce UNSAT cores.
(set-option :produce-unsat-cores true)
(set-option :smt.macro-finder true)
(declare-sort T6)
(declare-const v_14 T6)
(declare-const l1 T6)
(declare-const l2 T6)
(declare-sort T7)
(declare-const x T7)
(declare-const xs T6)
(declare-const sv_4103 T6)
(declare-const anc_24 T6)
(declare-fun Robs2 (T6 T7 T7) Bool)
(declare-fun Rmem1 (T6 T7) Bool)

(assert (! (forall ((bv1 T7) (bv0 T7)) (= (Robs2 l1 bv0 bv1) (or (and (= bv0 x) (Rmem1 xs bv1)) (Robs2 xs bv0 bv1)))) :named P110))
;
(assert (! (forall ((bv0 T7)) (= (Rmem1 l1 bv0) (or (= bv0 x) (Rmem1 xs bv0)))) :named P119))
;
(assert (! (forall ((bv0 T7)) (= (Rmem1 anc_24 bv0) (or (Rmem1 xs bv0) (Rmem1 l2 bv0)))) :named P123))
;
(assert (! (forall ((bv1 T7) (bv0 T7)) (= (Robs2 anc_24 bv0 bv1) (or (Robs2 xs bv0 bv1) (Robs2 l2 bv0 bv1)))) :named P125))
;
(assert (! (forall ((bv1 T7) (bv0 T7)) (= (Robs2 v_14 bv0 bv1) (or (and  (= bv0 x)(Rmem1 anc_24 bv1)) (Robs2 anc_24 bv0 bv1)))) :named P134))
;
(assert (! (forall ((bv0 T7)) (= (Rmem1 v_14 bv0) (or (= bv0 x) (Rmem1 anc_24 bv0)))) :named P143))

; Model specific assertions:
; So far, we were not concerned with models; so, we never had to
; assert properties of Robs, Roas etc. But if we want Z3 to generate
; models, then these properties have to be asserted to avoid generating
; spurious models.
  (assert (! (forall ((bv0 T7)) (= (Rmem1 xs bv0) false)) :named P120))
  (declare-const c0 T7)
  (assert (! (forall ((bv0 T7)) (= (Rmem1 l2 bv0) (= bv0 c0))) :named P121))
  (assert (! (forall ((bv0 T6) (bv1 T7) (bv2 T7)) (= (Robs2 bv0 bv1 bv2) (and (= bv0 v_14) (= bv1 x) (= bv2 c0)))) :named P144))
  ; Robs is irreflexive
  (assert (! (forall ((bv0 T6) (bv1 T7) (bv2 T7)) (=> (Robs2 bv0 bv1 bv2) (not (= bv1 bv2)))):named A0))
  ; Robs is asymmetric
  (assert (! (forall ((bv0 T6) (bv1 T7) (bv2 T7)) (=> (Robs2 bv0 bv1 bv2) (not (Robs2 bv0 bv2 bv1)))):named A1))
  ; Robs is transitive
  (assert (! (forall ((bv0 T6) (bv1 T7) (bv2 T7) (bv3 T7)) (=> (and (Robs2 bv0 bv1 bv2) (Robs2 bv0 bv2 bv3)) (Robs2 bv0 bv1 bv3))) :named A3))
; End model-specific assertions

;
(assert (! (forall ((bv1 T7) (bv0 T7)) (= (Robs2 v_14 bv0 bv1) (or (Robs2 l1 bv0 bv1) (Robs2 l2 bv0 bv1)))) :named P147))
(check-sat)
(get-model)
; unsat (P147 A1 P144 P121 P120 P143 P119 P123)
; Very bad unsat core. P147 and P144 are enough for refutation.
; If we do not track any model-specific assertion, Z3 just removes
; model-specific assertions from the above core. This unsat core is
; useless.
; The ideal unsat core (when we do not track model-specific
; assertions) is (P134 P123 P147). P134 says that 
; Robs(v_14) = {x} X Rmem(anc_24) U Robs(anc_24).
; P123 says: Rmem(anc_24) = Rmem(xs) U Rmem(l2)
; From the model we have Rmem(xs)={}, Rmem(l2)={c0} and Robs(anc_24)={}. 
; Which means, from P134:
; Robs(v_14) = {(x,c0)}
; However, from the model and spec assertion P147, we have:
; Robs(v_14) = {}
; --------------------
; Since {x} = Rmem(l1), and {c0} = Rmem(l2), there are only two ways
; to generate {(x,c0)}: via cross-products 
;  1. Rhd(l1) X Rhd(l2), and
;  2. Rmem(l1) X Rmem(l2)
; But, to perform above kind of reasoning, we don't need unsat cores.
; Do we? A model is sufficient.

