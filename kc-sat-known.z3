(set-option :smt.mbqi true)
(set-option :smt.macro-finder true)

(declare-sort Effect)
(declare-sort Session)

;; --------------------------------
(declare-fun vis!0 (Effect Effect) Bool)

;; --------------------------------
(declare-fun so!1 (Effect Effect) Bool)

;; --------------------------------
(declare-fun sess!2 (Effect) Session)

;; --------------------------------
(declare-fun idx!3 (Effect) Int)

;; --------------------------------
(declare-fun hb!4 (Effect Effect) Bool)

;; --------------------------------
(declare-const FA_E_!5 Effect)

;; --------------------------------
(declare-const FA_E_!6 Effect)

;; --------------------------------
;; Assert: VIS_ASYMM
(assert (forall ((FA_E_!5 Effect))
  (forall ((FA_E_!6 Effect))
    (=> (vis!0 FA_E_!5 FA_E_!6) (not (vis!0 FA_E_!6 FA_E_!5))))))
(push)
(check-sat)
;; Assert Result: Sat
(pop)
;; --------------------------------
(declare-const FA_E_!11 Effect)

;; --------------------------------
(declare-const FA_E_!12 Effect)

;; --------------------------------
;; Assert: SO_ASYMM
(assert (forall ((FA_E_!11 Effect))
  (forall ((FA_E_!12 Effect))
    (=> (so!1 FA_E_!11 FA_E_!12) (not (so!1 FA_E_!12 FA_E_!11))))))
(push)
(check-sat)
;; Assert Result: Sat
(pop)
;; --------------------------------
(declare-const FA_E_!21 Effect)

;; --------------------------------
(declare-const FA_E_!22 Effect)

;; --------------------------------
;; Assert: SO_DISJ_TO
(assert (forall ((FA_E_!21 Effect))
  (forall ((FA_E_!22 Effect))
    (ite (and (= (sess!2 FA_E_!21) (sess!2 FA_E_!22))
              (not (= FA_E_!21 FA_E_!22)))
         (or (so!1 FA_E_!21 FA_E_!22) (so!1 FA_E_!22 FA_E_!21))
         (not (or (so!1 FA_E_!21 FA_E_!22) (so!1 FA_E_!22 FA_E_!21)))))))
(push)
(check-sat)
;; Assert Result: Sat
(pop)
;; --------------------------------
(declare-const FA_E_!33 Effect)

;; --------------------------------
(declare-const FA_E_!34 Effect)

;; --------------------------------
(declare-const FA_E_!35 Effect)

;; --------------------------------
;; Assert: SO_TRANS
(assert (forall ((FA_E_!33 Effect))
  (forall ((FA_E_!34 Effect))
    (forall ((FA_E_!35 Effect))
      (=> (and (so!1 FA_E_!33 FA_E_!34) (so!1 FA_E_!34 FA_E_!35))
          (so!1 FA_E_!33 FA_E_!35))))))
(push)
(check-sat)
;; Assert Result: Sat
(pop)
;; --------------------------------
(declare-const FA_E_!49 Effect)

;; --------------------------------
(declare-const FA_I_!50 Int)

;; --------------------------------
;; Assert: IDX_GE_1
(assert (forall ((FA_E_!49 Effect))
  (forall ((FA_I_!50 Int)) (=> (= FA_I_!50 (idx!3 FA_E_!49)) (>= FA_I_!50 1)))))
(push)
(check-sat)
;; Assert Result: Sat
(pop)
;; --------------------------------
(declare-const FA_E_!86 Effect)

;; --------------------------------
(declare-const EX_E_!87 Effect)

;; --------------------------------
;; Assert: EXIST_PREV_IDX_GT_1
(assert (forall ((FA_E_!86 Effect))
  (let ((a!1 (exists ((EX_E_!87 Effect))
               (and (= (sess!2 FA_E_!86) (sess!2 EX_E_!87))
                    (= (idx!3 EX_E_!87) (- (idx!3 FA_E_!86) 1))
                    (so!1 EX_E_!87 FA_E_!86)))))
    (=> (> (idx!3 FA_E_!86) 1) a!1))))
(push)
(check-sat)
;; Assert Result: Sat
(pop)
;; --------------------------------
(declare-const FA_E_!122 Effect)

;; --------------------------------
(declare-const FA_E_!123 Effect)

;; --------------------------------
;; Assert: SO_FOLLOWS_IDX
(assert (forall ((FA_E_!122 Effect))
  (forall ((FA_E_!123 Effect))
    (=> (so!1 FA_E_!122 FA_E_!123) (< (idx!3 FA_E_!122) (idx!3 FA_E_!123))))))
(push)
(check-sat)
;; Assert Result: Sat
(pop)
;; --------------------------------
(declare-const FA_E_!161 Effect)

;; --------------------------------
(declare-const FA_E_!162 Effect)

;; --------------------------------
;; Assert: EQ_ADDR_EFF_1
(assert (forall ((FA_E_!161 Effect))
  (forall ((FA_E_!162 Effect))
    (=> (and (= (idx!3 FA_E_!161) (idx!3 FA_E_!162))
             (= (sess!2 FA_E_!161) (sess!2 FA_E_!162)))
        (= FA_E_!161 FA_E_!162)))))
(push)
(check-sat)
;; Assert Result: Sat
(pop)
;; --------------------------------
(declare-const FA_E_!204 Effect)

;; --------------------------------
(declare-const FA_E_!205 Effect)

;; --------------------------------
;; Assert: EQ_ADDR_EFF_2
(assert (forall ((FA_E_!204 Effect))
  (forall ((FA_E_!205 Effect))
    (=> (= FA_E_!204 FA_E_!205)
        (and (= (idx!3 FA_E_!204) (idx!3 FA_E_!205))
             (= (sess!2 FA_E_!204) (sess!2 FA_E_!205)))))))
(push)
(check-sat)
;; Assert Result: Sat
(pop)
;; --------------------------------
(declare-const FA_E_!251 Effect)

;; --------------------------------
(declare-const FA_E_!252 Effect)

;; --------------------------------
;; Assert: HB_FOLLOWS_VIS_N_SO
(assert (forall ((FA_E_!251 Effect))
  (forall ((FA_E_!252 Effect))
    (=> (or (vis!0 FA_E_!251 FA_E_!252) (so!1 FA_E_!251 FA_E_!252))
        (hb!4 FA_E_!251 FA_E_!252)))))
(push)
(check-sat)
;; Assert Result: Sat
(pop)
;; --------------------------------
(declare-const FA_E_!298 Effect)

;; --------------------------------
(declare-const FA_E_!299 Effect)

;; --------------------------------
(declare-const FA_E_!300 Effect)

;; --------------------------------
;; Assert: HB_TRANS
(assert (forall ((FA_E_!298 Effect))
  (forall ((FA_E_!299 Effect))
    (forall ((FA_E_!300 Effect))
      (=> (and (hb!4 FA_E_!298 FA_E_!299) (hb!4 FA_E_!299 FA_E_!300))
          (hb!4 FA_E_!298 FA_E_!300))))))
(push)
(check-sat)
;; Assert Result: Sat
(pop)
;; --------------------------------
(declare-const FA_E_!352 Effect)

;; --------------------------------
(declare-const FA_E_!353 Effect)

;; --------------------------------
;; Assert: HB_ASYMM
(assert (forall ((FA_E_!352 Effect))
  (forall ((FA_E_!353 Effect))
    (=> (hb!4 FA_E_!352 FA_E_!353) (not (hb!4 FA_E_!353 FA_E_!352))))))
(push)
(check-sat)
;; Assert Result: Sat
(pop)
;; --------------------------------
(declare-fun known!409 (Effect) Bool)

;; --------------------------------
(declare-fun unknown!410 (Effect) Bool)

;; --------------------------------
(declare-const FA_E_!411 Effect)

;; --------------------------------
;; Assert: K_EMP
(assert (forall ((FA_E_!411 Effect)) (not (known!409 FA_E_!411))))
(push)
(check-sat)
;; Assert Result: Sat
(pop)
;; --------------------------------
(declare-const FA_E_!473 Effect)

;; --------------------------------
;; Assert: UK_EMP
(assert (forall ((FA_E_!473 Effect)) (not (unknown!410 FA_E_!473))))
(push)
(check-sat)
;; Assert Result: Sat
(pop)
;; --------------------------------
(declare-const sid_!541 Session)

;; --------------------------------
(declare-const eff_!542 Effect)

;; --------------------------------
;; Assert: ADD_EFF_SESS
(assert (= (sess!2 eff_!542) sid_!541))
(push)
(check-sat)
;; Assert Result: Sat
(pop)
;; --------------------------------
;; Assert: ADD_EFF_IDX
(assert (= (idx!3 eff_!542) 1))
(push)
(check-sat)
;; Assert Result: Sat
(pop)
;; --------------------------------
(declare-fun known!642 (Effect) Bool)

;; --------------------------------
(declare-const FA_E_!643 Effect)

;; --------------------------------
;; Assert: EXT_SET
(assert (forall ((FA_E_!643 Effect))
  (ite (= FA_E_!643 eff_!542)
       (known!642 eff_!542)
       (= (known!642 FA_E_!643) (known!409 FA_E_!643)))))
(push)
(check-sat)
;; Assert Result: Sat
(pop)
;; --------------------------------
(declare-const FA_E_!710 Effect)

;; --------------------------------
;; Assert: ADD_K_EFF_EMP_VIS
(assert (forall ((FA_E_!710 Effect)) (not (vis!0 FA_E_!710 eff_!542))))
(push)
(check-sat)
;; Assert Result: Sat
(pop)
;; --------------------------------
(declare-const sid_!779 Session)

;; --------------------------------
(declare-const eff_!780 Effect)

;; --------------------------------
;; Assert: ADD_EFF_SESS
(assert (= (sess!2 eff_!780) sid_!779))
(push)
(check-sat)
;; Assert Result: Sat
(pop)
;; --------------------------------
;; Assert: ADD_EFF_IDX
(assert (= (idx!3 eff_!780) 2))
(push)
(check-sat)
;; Assert Result: Sat
(pop)
;; --------------------------------
(declare-fun known!1073 (Effect) Bool)

;; --------------------------------
(declare-const FA_E_!1074 Effect)

;; --------------------------------
;; Assert: EXT_SET
(assert (forall ((FA_E_!1074 Effect))
  (ite (= FA_E_!1074 eff_!780)
       (known!1073 eff_!780)
       (= (known!1073 FA_E_!1074) (known!642 FA_E_!1074)))))
(push)
(check-sat)
;; Assert Result: Sat
(pop)
;; --------------------------------
(declare-const eff_!1264 Effect)

;; --------------------------------
;; Assert: ADD_EFF_SESS
(assert (= (sess!2 eff_!1264) sid_!779))
(push)
(check-sat)
;; Assert Result: Sat
(pop)
;; --------------------------------
;; Assert: ADD_EFF_IDX
(assert (= (idx!3 eff_!1264) 1))
(push)
(check-sat)
;; Assert Result: Sat
(pop)
;; --------------------------------
(declare-fun unknown!1610 (Effect) Bool)

;; --------------------------------
(declare-const FA_E_!1611 Effect)

;; --------------------------------
;; Assert: EXT_SET
(assert (forall ((FA_E_!1611 Effect))
  (ite (= FA_E_!1611 eff_!1264)
       (unknown!1610 eff_!1264)
       (= (unknown!1610 FA_E_!1611) (unknown!410 FA_E_!1611)))))
(push)
(check-sat)
;; Assert Result: Sat
(pop)
;; --------------------------------
(declare-const FA_E_!1768 Effect)

;; --------------------------------
;; Assert: ADD_U_EFF
(assert (forall ((FA_E_!1768 Effect)) (not (vis!0 FA_E_!1768 eff_!1264))))
(push)
(check-sat)
;; Assert Result: Sat
(pop)
;; --------------------------------
(declare-const FA_E_!1971 Effect)

;; --------------------------------
;; Assert: ADD_K_EFF_EMP_VIS
(assert (forall ((FA_E_!1971 Effect)) (not (vis!0 FA_E_!1971 eff_!780))))
(push)
(check-sat)
;; Assert Result: Sat
(pop)
;; --------------------------------
(declare-const eff_!2172 Effect)

;; --------------------------------
;; Assert: ADD_EFF_SESS
(assert (= (sess!2 eff_!2172) sid_!541))
(push)
(check-sat)
;; Assert Result: Sat
(pop)
;; --------------------------------
;; Assert: ADD_EFF_IDX
(assert (= (idx!3 eff_!2172) 2))
(push)
(check-sat)
;; Assert Result: Sat
(pop)
;; --------------------------------
(declare-const FA_E_!2630 Effect)

;; --------------------------------
(declare-const FA_E_!2631 Effect)

;; --------------------------------
;; Assert: HB_ORIG_K_U
(assert (forall ((FA_E_!2630 Effect))
  (forall ((FA_E_!2631 Effect))
    (=> (hb!4 FA_E_!2630 FA_E_!2631)
        (or (known!1073 FA_E_!2630) (unknown!1610 FA_E_!2630))))))
(push)
(check-sat)
;; Assert Result: Sat
(pop)
;; --------------------------------
(declare-const FA_E_!2842 Effect)

;; --------------------------------
(declare-const FA_E_!2843 Effect)

;; --------------------------------
(declare-const EX_E_!2844 Effect)

;; --------------------------------
;; Assert: HB_BRK_VIS_SO
(assert (forall ((FA_E_!2842 Effect))
  (forall ((FA_E_!2843 Effect))
    (let ((a!1 (or (so!1 FA_E_!2842 FA_E_!2843)
                   (vis!0 FA_E_!2842 FA_E_!2843)
                   (exists ((EX_E_!2844 Effect))
                     (and (hb!4 FA_E_!2842 EX_E_!2844)
                          (hb!4 EX_E_!2844 FA_E_!2843))))))
      (=> (hb!4 FA_E_!2842 FA_E_!2843) a!1)))))
(push)
(check-sat)
;; Assert Result: Sat
(pop)
;; --------------------------------
(declare-const FA_E_!3066 Effect)

;; --------------------------------
;; Assert: UK_IMPL_N_K
(assert (forall ((FA_E_!3066 Effect))
  (=> (unknown!1610 FA_E_!3066) (not (known!1073 FA_E_!3066)))))
(push)
(check-sat)
;; Assert Result: Sat
(pop)
;; --------------------------------
(declare-const FA_E_!3293 Effect)

;; --------------------------------
;; Assert: K_IMPL_N_UK
(assert (forall ((FA_E_!3293 Effect))
  (=> (known!1073 FA_E_!3293) (not (unknown!1610 FA_E_!3293)))))
(push)
(check-sat)
;; Assert Result: Sat
(pop)
(push)
(check-sat)
(pop)
(push)
;; --------------------------------
(declare-const FA_E_!4202 Effect)

;; --------------------------------
;; Assert: K_IMPL_VIS
(assert (forall ((FA_E_!4202 Effect))
  (ite (known!1073 FA_E_!4202)
       (vis!0 FA_E_!4202 eff_!2172)
       (not (vis!0 FA_E_!4202 eff_!2172)))))
(push)
(check-sat)
;; Assert Result: Sat
(pop)
;; --------------------------------
(declare-const FA_E_!4647 Effect)

;; --------------------------------
(declare-const FA_E_!4648 Effect)

;; --------------------------------
;; Assert: K_CHECK
(assert (let ((a!1 (forall ((FA_E_!4647 Effect))
             (forall ((FA_E_!4648 Effect))
               (=> (and (so!1 FA_E_!4647 FA_E_!4648)
                        (vis!0 FA_E_!4648 eff_!2172))
                   (vis!0 FA_E_!4647 eff_!2172))))))
  (not a!1)))

(check-sat)

