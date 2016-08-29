;; Proof that if
;;    (Rmem R)(l) = R(x) U (Rmem R)(xs)
;; is encoded as 
;;    RmemR(l) = R(x) U RmemR2(xs)
;; after adding (same) map axioms to define RmemR
;; and RmemR2, RmemR is still equivalent to RmemR2.
(declare-sort T)
(declare-sort T0)
(declare-sort T1)
(declare-const l T)
(declare-const x T0)
(declare-const xs T)
(declare-const b0 Bool)
(declare-const b1 Bool)
(declare-const b2 Bool)
(declare-const b3 Bool)
(declare-const b4 Bool)
(declare-fun Rmem (T T0) Bool)
(declare-fun R (T0 T1) Bool)
(declare-fun RmemR (T T1) Bool)
(declare-fun RmemR2 (T T1) Bool)
(assert (= b0 (forall ((l1 T)(k0 T0)(k1 T1)) (=>
    (and (Rmem l1 k0) (R k0 k1))
    (RmemR l1 k1)
))))
(assert (= b1 (forall ((l1 T)(k1 T1)) (exists ((k0 T0)) (=>
    (RmemR l1 k1)
    (and (Rmem l1 k0) (R k0 k1))
)))))
(assert (and b0 b1))
(assert (= b2 (forall ((l1 T)(k0 T0)(k1 T1)) (=>
    (and (Rmem l1 k0) (R k0 k1))
    (RmemR2 l1 k1)
))))
(assert (= b3 (forall ((l1 T)(k1 T1)) (exists ((k0 T0)) (=>
    (RmemR2 l1 k1)
    (and (Rmem l1 k0) (R k0 k1))
)))))
(assert (and b2 b3))
(assert (forall ((k1 T1)) (=
  (RmemR l k1)
  (or (R x k1) (RmemR2 xs k1))
)))
(assert (= b4 (forall ((k T1)) (=
  (RmemR l k) (RmemR2 l k)
))))
(assert (not b4))
(check-sat)
