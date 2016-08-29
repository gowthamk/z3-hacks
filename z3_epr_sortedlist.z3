    (set-option :mbqi true)
    (set-option :model-compact true)

    (declare-fun S (Int) Bool)
    (declare-fun preceeds (Int Int) Bool)
    (declare-fun occurs-before (Int Int) Bool)

    ;; preceeds is anti-reflexive
    (assert (forall ((x Int)) (=> (S x) (not (preceeds x x)))))

    ;; preceeds is monotonic
    (assert (forall ((x Int) (y Int)) (=> (and (S x) (and (S y) (and (preceeds x y))))
                                           (not (preceeds y x)))))
    ;; preceeds is a function
    (assert (forall ((x Int) (y Int) (z Int)) (=> (and (S x) (and (S y) (and (S z) (and (preceeds x y)
                                                 (preceeds x z)))))
                                                 (= y z))))
    ;; preceeds induces local order
    (assert (forall ((x Int) (y Int)) (=> (and (S x) (and (S y) (preceeds x y)))
                                           (< x y))))
                                           
    ;; preceeds implies occurs-before
    (assert (forall ((x Int) (y Int)) (=> (and (and (S x) (S y)) (preceeds x y)) 
                                                 (occurs-before x y))))
                                                 
    ;;occurs-before is transitivie
    (assert (forall ((x Int)(y Int)(z Int))  
      (=> (and (S x) (and (S y) (and (S z)(and (occurs-before x y) (occurs-before y z))))) 
        (occurs-before x z))
    ))                
                                 
    (declare-const h Int)
    (assert (S h))
    (assert (forall ((x Int)) (=> (S x) (occurs-before h x))))  
    (assert (forall ((y Int)) (=> (S y) (= h y))))
    (check-sat)
    (get-model)                                                                           
