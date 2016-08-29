;; Z3 proof for reverse

(set-option :mbqi true)
(set-option :model-compact true)
(declare-sort T)
(declare-sort Tx)
;(define-sort T () Int)
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
(declare-fun Robsxs ((Pair T)) Bool)
(declare-fun Robsl ((Pair T)) Bool)
(declare-fun R ((Pair T) Tx) Bool)
(declare-fun RobslR (Tx) Bool)
(declare-fun Roasxs1 ((Pair T)) Bool)
(declare-fun Roasx1 ((Pair T)) Bool)
(declare-fun Roasv ((Pair T)) Bool)
(declare-fun RoasvR (Tx) Bool)
;; Rmeml is {x} U Rmemxs
(assert (forall ((n T)) (= (Rmeml n)(or (Rmemxs n) (= n x)))))
;; Robsl is {{x} X Rmemxs} U Robsxs
;; C is {x} X Rmemxs
(declare-fun C ((Pair T)) Bool)
(assert (forall ((y T)(n T)) (= (and (Rmemxs n)(= y x))(C (mk-pair y n)))))
(assert (forall ((n (Pair T))) (= (Robsl n)(or (C n) (Robsxs n)))))
;; Rmemxs1 = Rmemxs
(assert (forall ((n T)) (= (Rmemxs1 n)(Rmemxs n))))
;; Roasxs1 = Robsxs
(assert (forall ((n (Pair T)))(= (Roasxs1 n)(Robsxs n))))
;; Rmemx1 = {x}
(assert (forall ((n T)) (= (Rmemx1 n)(= n x))))
;; Roasx1 = {}
(assert (forall ((n (Pair T))) (= (Roasx1 n) false)))
;; Rmemv = Rmemxs1 U Rmemx1
(assert (forall ((n T)) (= (Rmemv n)(or (Rmemxs1 n) (Rmemx1 n)))))
;; Roasv = Roasxs1 U Roasx1 U (Rmemx1 X Rmemxs1)
(declare-fun A ((Pair T)) Bool)
(assert (forall ((n (Pair T))) (= (A n)(or (Roasxs1 n) (Roasx1 n)))))
(declare-fun B ((Pair T)) Bool)
(assert (forall ((n1 T)(n2 T)) (= (B (mk-pair n1 n2))(and (Rmemx1 n1) (Rmemxs1
n2)))))
(assert (forall ((n (Pair T))) (= (Roasv n)(or (A n) (B n)))))
;; Goal
(declare-const conj1 Bool)
(declare-const conj2 Bool)
(declare-const conj3 Bool)
;;(assert (= conj1 (forall ((n T)) (= (Rmemv n) (Rmeml n)))))
;;(assert (= conj2 (forall ((n (Pair T))) (= (Roasv n) (Robsl n)))))
;; Assertions relating Roasv to RoasvR
(assert (forall ((n0 (Pair T)) (n1 Tx)) (=> 
    (and (Roasv n0) (R n0 n1))
    (RoasvR n1)
)))
(assert (forall ((n1 Tx)) (exists ((n0 (Pair T))) (=>
    (RoasvR n1) 
    (and (Roasv n0) (R n0 n1))
))))
;; Assertions relating Robsl to RobslR
(assert (forall ((n0 (Pair T)) (n1 Tx)) (=> 
    (and (Robsl n0) (R n0 n1))
    (RobslR n1)
)))
(assert (forall ((n1 Tx)) (exists ((n0 (Pair T))) (=>
    (RobslR n1) 
    (and (Robsl n0) (R n0 n1))
))))
;; Assertion for parametric Robsl and Roasv
(assert (= conj3 (forall ((n Tx)) (= (RoasvR n) (RobslR n)))))
(assert (not conj3))
;;(assert (not (and conj1 conj2)))
;;(assert (not conj2))
;; 
(check-sat)
(get-model)


