(set-option :smt.mbqi true)
(set-option :produce-unsat-cores true)
;; A, B, C and D are sets of Int
(declare-sort T)
(declare-const c0 T)
(declare-const c1 T)
(declare-const c2 T)
(declare-fun A (T) Bool)
(declare-fun B (T) Bool)
(declare-fun C (T) Bool)
(declare-fun D (T) Bool)

;; A union B is a subset of C
(assert (! (forall ((x T)) (=> (or (A x) (B x)) (C x))) :named a1))

;; B minus A is not empty
;; That is, there exists an integer e that is B but not in A
(declare-const e T)
(assert (! (and (B e) (not (A e))) :named a2))

;; D is equal to C
(assert (! (forall ((x T)) (iff (D x) (C x))) :named a3))
;; But, D has an element not in C
(assert (! (exists ((x T)) (and (D x) (not (C x)))) :named a4))

;; c0, c1 and c2 are in B
(assert (! (B c0) :named a5))
(assert (! (B c1) :named a6))
(assert (! (B c2) :named a7))

(check-sat)
(get-unsat-core)
; finds a3 and a4 as unsat core
