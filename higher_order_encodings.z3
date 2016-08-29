(set-option :mbqi false)
(set-option :macro-finder true)

;; Failed attempt
(declare-sort T0)
(declare-sort T1)
(declare-sort T2)
(declare-fun R (T0 T1) Bool)
(declare-fun f1 (T2) Bool)
(declare-fun f2 (T2) Bool)
;; Rf1 and Rf2 are instantiations of R relation with
;; f1 and f2. 
;; For now, assume that we don't have expansions for 
;; Rf1 and Rf2
(declare-fun Rf1 (T0 T1) Bool)
(declare-fun Rf2 (T0 T1) Bool)
(assert (forall ((x T0)(y T1)) (exists ((z T2)) (= (Rf1 x y) 
  (and (R x y) (f1 z))))))
(assert (forall ((x T0)(y T1)) (exists ((z T2)) (= (Rf2 x y) 
  (and (R x y) (f2 z))))))
(assert (forall ((x T2)) (= (f1 x) (f2 x))))
(assert (not (forall ((x T0) (y T1)) (= (Rf1 x y) (Rf2 x y)))))
(check-sat)
(get-model)

;; Attempt2
;; works
;; Found to be unsound
(declare-sort T0)
(declare-sort T1)
(declare-sort T2)
(declare-fun Ra (T0 T2) Bool)
(declare-fun Rb (T2 T1) Bool)
(declare-fun f1 (T2) Bool)
(declare-fun f2 (T2) Bool)
;; Rf1 and Rf2 are instantiations of R relation with
;; f1 and f2. 
;; For now, assume that we don't have expansions for 
;; Rf1 and Rf2
(declare-fun Rf1 (T0 T1) Bool)
(declare-fun Rf2 (T0 T1) Bool)
(assert (forall ((x T0)(y T1)(z T2)) (= (Rf1 x y) 
  (and (Ra x z) (f1 z) (Rb z y)))))
(assert (forall ((x T0)(y T1)(z T2)) (= (Rf2 x y) 
  (and (Ra x z) (f2 z) (Rb z y)))))
(assert (forall ((x T2)) (= (f1 x) (f2 x))))
(assert (not (forall ((x T0) (y T1)) (= (Rf1 x y) (Rf2 x y)))))
(check-sat)
(get-model)

;; Attemp3 Consider an uninterpreted boolean function R that is
; parametrized over another uninterpreted boolean function f. For the
; sake of simplicity, assume f to be a first-order uninterpreted
; function , i.e., f has sort Ti -> bool, for some uninterpreted sort
; Ti. Also, assume that R has sort (Ti -> Bool) -> Tj -> Bool.

;; Look into this.
;; Looked. The reason it fails is because f can be 
;; attached an interpretation independently of the
;; stated assertions.
;; For eg, an assertion Rf1 = {()} makes f return false
;; for any instantiation of R.
(set-option :mbqi false)
(set-option :macro-finder true)
(declare-sort T0)
(declare-sort T1)
(declare-fun f1 (T1) Bool)
(declare-fun f2 (T1) Bool)
;; Rf1 and Rf2 are instantiations of R relation with
;; f1 and f2. 
(declare-fun Rf1 (T0 T1) Bool)
(declare-fun Rf2 (T0 T1) Bool)
(declare-const a Bool)
(assert (= a (=> 
  (forall ((x T1)) (= (f1 x) (f2 x)))
  (forall ((l T0) (x T1)) (= (Rf1 l x) (Rf2 l x)))
)))

(declare-fun f (Bool) Bool)
(assert (forall ((x bool) (y bool)) (=> 
  (not (= x y))
  (not (= (f x) (f y)))
)))
(declare-const b Bool)
(assert (= b (and 
  (forall ((l T0)(x T1)) (= (f (f1 x)) (Rf1 l x)))
  (forall ((l T0)(x T1)) (= (f (f2 x)) (Rf2 l x)))
)))
(assert (not (= a b)))
(check-sat)
(get-model)

;; Array'fy everything.
(set-option :mbqi false)
(set-option :macro-finder true)
(declare-sort T0)
(declare-sort T1)
(declare-fun f1 (T1) Bool)
(declare-fun f2 (T1) Bool)
;; Rf1 and Rf2 are instantiations of R relation with
;; f1 and f2. 
(declare-const af1 (Array T1 Bool))
(declare-const af2 (Array T1 Bool))
(declare-fun R ((Array T1 Bool) T0 T1) Bool)
(assert (forall ((x T1)) (= (select af1 x) (select af2 x))))
(declare-const a Bool)
(assert (= a (forall ((l T0) (x T1)) (= (R af1 l x) (R af2 l x)))))
(assert (not a))
(check-sat)
(get-model)

;; Higher-Order arrays are also possible!
(set-option :mbqi false)
(set-option :macro-finder true)
(declare-sort T0)
(declare-sort T1)
(declare-const af1 (Array T1 Bool))
(declare-const af2 (Array T1 Bool))
(declare-const ho-array (Array (Array T1 Bool) T1 Bool))
(assert (forall ((x T1)) (= (select af1 x) (select af2 x))))
(declare-const a Bool)
(assert (= a (forall ((x T1)) (= (select ho-array af1 x) (select ho-array af2 x)))))
(assert (not a))
(check-sat)
(get-model)
