; Wrong implementation of concat:
; fun concat (l1:'a list) (l2:'a list) = case l1 of
;   [] => []
; | x::xs => x::(concat xs l2)
; Being checked against the following spec:
; Rmem(l) = Rmem(l1) U Rmem(l2)
; Produced following model:
; Rmem(l1) = {}, Rmem(l2) = {c0}
; We now make use of the unsatisfiability of the spec for this model
; to produce UNSAT cores.
(set-option :produce-unsat-cores true)
(declare-sort T0)
(declare-const v_14 T0)
(declare-const x_1 T0)
(declare-const x_0 T0)
(declare-const anc_18 T0)
(declare-const anc_19 T0)
(declare-const l1 T0)
(declare-const l2 T0)
(declare-const sv_4100 T0)
(declare-sort T1)
(declare-const c0 T1)
(declare-fun Rmem4 (T0 T1) Bool)
(assert (! (= anc_19 x_1) :named P0))
(assert (! (= anc_18 x_0) :named P1))
(assert (! (= l2 x_1) :named P2))
(assert (! (= l2 anc_19) :named P3))
(assert (! (= l1 x_0) :named P4))
(assert (! (= l1 anc_18) :named P5))
(declare-fun set4 (T1) Bool)
(assert (! (forall ((bv0 T1)) (= (set4 bv0) false)) :named P14))
(assert (! (forall ((bv0 T1)) (= (Rmem4 l1 bv0) (set4 bv0))) :named P15))
(declare-fun set5 (T1) Bool)
(assert (! (forall ((bv0 T1)) (= (set5 bv0) (= bv0 c0))) :named P16))
(assert (! (forall ((bv0 T1)) (= (Rmem4 l2 bv0) (set5 bv0))) :named P17))
(declare-fun set10 (T1) Bool)
(assert (! (forall ((bv0 T1)) (= (set10 bv0) false)) :named P26))
(assert (! (forall ((bv0 T1)) (= (Rmem4 v_14 bv0) (set10 bv0))) :named P27))
(declare-fun set12 (T1) Bool)
(assert (! (forall ((bv0 T1)) (= (set12 bv0) (or (Rmem4 x_0 bv0) (Rmem4 x_1 bv0)))) :named P30))
(assert (! (forall ((bv0 T1)) (= (Rmem4 v_14 bv0) (set12 bv0))) :named P31))
(check-sat)
(get-model)
(get-unsat-core)

; unsat (P31 P30 P27 P26 P17 P2 P16)
; Succinctly, UNSAT core can be represented as following:
; l2 = x1; Rmem4(l2) = {c0}; Rmem4(v_14) = {}; 
; Rmem4(v_14) = Rmem4(x0) U Rmem4(x1)
