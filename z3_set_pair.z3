(declare-sort A)
(declare-datatypes (T1 T2) ((Pair (mk-pair (first T1) (second T2)))))
(define-sort Set (T) (Array T Bool))
(define-fun set-union ((x (Set (Pair A A))) (y (Set (Pair A A)))) 
  (Set (Pair A A)) ((_ map or) x y))

(declare-const S1 (Set (Pair A A)))
(declare-const S2 (Set (Pair A A)))
(declare-const S3 (Set (Pair A A)))
(declare-const p1 (Pair A A))
(declare-const ps1 (Set (Pair A A)))
(declare-const p2 (Pair A A))
(declare-const ps2 (Set (Pair A A)))
(declare-const a A)
(declare-const b A)
(assert (= ps1 ((as const (Set (Pair A A))) false)))
(assert (= true (select ps1 p1)))
(assert (= S1 (set-union S2 ps1)))

(assert (= p2 (mk-pair a b)))
(assert (= ps2 ((as const (Set (Pair A A))) false)))
(assert (= true (select ps2 p2)))
(assert (= S3 (set-union S2 ps2)))
(assert (not (= (set-union S1 ps2) (set-union S3 ps1))))

(check-sat)
(get-model)

