(set-option :mbqi false)
(set-option :model-compact true)
(declare-sort T)
;; (declare-sort Tx)
;; A, B, C and D are sets of Int
(declare-fun Rmeml (T) Bool)
(declare-fun RmemlR (T T) Bool)
(declare-fun Rmemv (T) Bool)
(declare-fun RmemvR (T T) Bool)
;; Declare constants 
(declare-const x T)
;; Declare tuple type
(declare-fun R (T T T) Bool)
;; Goal
(declare-const conj3 Bool)
;; Assertion about Rdup
(assert (forall ((x T) (y T) (z T)) (= (R x y z) (and (= y x) (= z x)))))
;; Assertions relating Rmemv to RmemvR
(assert (forall ((n0 T) (n1 T) (n2 T)) (=>
    (and (Rmemv n0) (R n0 n1 n2))
    (RmemvR n1 n2)
)))
(assert (forall ((n1 T) (n2 T)) (exists ((n0 T)) (=>
    (RmemvR n1 n2)
    (and (Rmemv n0) (R n0 n1 n2))
))))
;; Assertions relating Rmeml to RmemlR
(assert (forall ((n0 T) (n1 T) (n2 T)) (=>
    (and (Rmeml n0) (R n0 n1 n2))
    (RmemlR n1 n2)
)))
(assert (forall ((n1 T) (n2 T)) (exists ((n0 T)) (=>
    (RmemlR n1 n2)
    (and (Rmeml n0) (R n0 n1 n2))
))))
;; We assert parametric relations (Rmem Rdup) are equal
(assert (forall ((n1 T) (n2 T)) (= (RmemlR n1 n2) (RmemvR n1 n2))))
;; are non parametric relations equal?
(assert (= conj3 (forall ((n T)) (= (Rmeml n) (Rmemv n)))))
(assert (not conj3))
(check-sat)
(get-model)
