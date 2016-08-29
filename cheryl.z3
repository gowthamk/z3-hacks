;; Months
(define-sort M () (_ BitVec 2))
(declare-const may M)
(assert (= may #b00))
(declare-const june M)
(assert (= june #b01))
(declare-const july M)
(assert (= july #b10))
(declare-const aug M)
(assert (= aug #b11))
;; Days
(define-sort D () (_ BitVec 3))
(declare-const _14 D)
(assert (= _14 #b000))
(declare-const _15 D)
(assert (= _15 #b001))
(declare-const _16 D)
(assert (= _16 #b010))
(declare-const _17 D)
(assert (= _17 #b011))
(declare-const _18 D)
(assert (= _18 #b100))
(declare-const _19 D)
(assert (= _19 #b101))
;; What is a date?
(define-fun isDate ((m M)(d D)) Bool
  (or (and (= m may) (or (= d _15) (= d _16) (= d _19)))
      (and (= m june) (or (= d _17) (= d _18)))
      (and (= m july) (or (= d _14) (= d _16)))
      (and (= m aug) (or (= d _14) (= d _15) (= d _17)))))
;; So far we have only set up the stage. We now assert what Albert and
;; Bernard say
(declare-const bdaym M)  
(declare-const bdayd D) 
(define-fun hasManyDays ((m M)) Bool
  (exists ((d1 D) (d2 D))
    (and (not (= d1 d2)) (isDate bdaym d1) (isDate bdaym d2))))
(define-fun hasNoUniqueDay ((m M)) Bool
  (forall ((d D)) (=> (isDate m d)
    (exists ((_m M)) (and (not (= _m m)) (isDate _m d))))))
(declare-const aDoesntKnow Bool)
;; Albert cannot know the date by knowing the month if and only if the
;; month contains many days.
(assert (= aDoesntKnow (hasManyDays bdaym)))
(declare-const aKnowsBDoesnt Bool)
;; Albert was certain that Bernard does not know the month although he
;; knows the date. This is possible if and only if every day in the
;; month can also occur in a different month.
(assert (= aKnowsBDoesnt (hasNoUniqueDay bdaym)))
;; Albert doesn't know and he knows that Bernard doesn't either
(assert (and aDoesntKnow aKnowsBDoesnt))
;; Since Bernard says that he now knows, any month that satisfies
;; hasManyDays and hasNoUniqueDay predicates, while containing bdayd
;; must be unique, and it is bdaym
;; d is a day such that there is only month m, which contains this day
;; and satisfies whatever Albert said about the bday month. 
(define-fun determinesBdayM ((d D)) Bool
  (forall ((m M)) 
          (=> (and (hasManyDays m) (hasNoUniqueDay m)
                   (isDate m d)) 
              (= m bdaym))))
(assert (determinesBdayM bdayd))
;; Since Albert says he also knows now, there is only one day in the
;; month bdaym that determinesBdayM. That day is the bdayd.
(assert (forall ((d D)) 
  (=> (and (isDate bdaym d) (determinesBdayM d)) 
  (= d bdayd))))
(check-sat)
(get-model)
(echo "Model for bdaym must be b10 (July) and bdayd must be b010(_16)")
