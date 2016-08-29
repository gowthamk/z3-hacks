(set-option :mbqi false)
(set-option :model-compact true)
(declare-sort T)
;; (declare-sort Tx)
;; A, B, C and D are sets of Int
(declare-fun Rmemxs (T) Bool)
(declare-fun Rmeml (T) Bool)
(declare-fun Rmemxs1 (T) Bool)
(declare-fun Rmemv (T) Bool)
(declare-fun Rmemx1 (T) Bool)
;; Declare constants 
(declare-const x T)
(declare-const x1 T)
;; Declare tuple type
(declare-datatypes (T) ((Pair (mk-pair (first T) (second T)))))
(define-sort Tx () (Pair T))
(declare-fun Robsxs ((Pair T)) Bool)
(declare-fun Robsl ((Pair T)) Bool)
(declare-fun R ((Pair T) T) Bool)
(declare-fun RobslR (T) Bool)
(declare-fun Roasxs1 ((Pair T)) Bool)
(declare-fun Roasx1 ((Pair T)) Bool)
(declare-fun Roasv ((Pair T)) Bool)
(declare-fun RoasvR (T) Bool)
;; Goal
(declare-const conj1 Bool)
(declare-const conj2 Bool)
(declare-const conj3 Bool)
;; Assertion about R
(assert (forall ((x (Pair T)) (y T)) (= (R x y) (= y (first x)))))
;; Assertions relating Roasv to RoasvR
(assert (forall ((n0 (Pair T)) (n1 T)) (=>
    (and (Roasv n0) (R n0 n1))
    (RoasvR n1)
)))
(assert (forall ((n1 T)) (exists ((n0 (Pair T))) (=>
    (RoasvR n1)
    (and (Roasv n0) (R n0 n1))
))))
;; Assertions relating Robsl to RobslR
(assert (forall ((n0 (Pair T)) (n1 T)) (=>
    (and (Robsl n0) (R n0 n1))
    (RobslR n1)
)))
(assert (forall ((n1 T)) (exists ((n0 (Pair T))) (=>
    (RobslR n1)
    (and (Robsl n0) (R n0 n1))
))))
;; We assert parametric relations are equal
(assert (forall ((n1 T)) (= (RobslR n1) (RoasvR n1))))
;; are non parametric relations equal?
(assert (= conj3 (forall ((n (Pair T))) (= (Robsl n) (Roasv n)))))
(assert (not conj3)) 
(check-sat)
(get-model)
