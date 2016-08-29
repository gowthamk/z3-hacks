(declare-const p Bool)
(declare-const q Bool)
(declare-const r Bool)
(define-fun conjecture () Bool
  (= (or p (and (not p) q))
    (or q (and (not q) p))))
(assert (not conjecture))
(check-sat)
