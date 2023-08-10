;; Exercise 2.32. We can represent a set as a list of distinct elements,
;; and we can represent the set of all subsets of the set as a list of
;; lists. For example, if the set is (1 2 3), then the set of all subsets
;; is: (() (3) (2) (2 3) (1) (1 3) (1 2) (1 2 3)).
;; Complete the following definition of a procedure that generates the
;; set of subsets of a set and give a clear explanation of why it works:

(define (subsets s)
  (if (null? s)
      (list ())
      (let ((rest (subsets (cdr s))))
        (append rest (map (lambda (x) (append (list (car s)) x)) rest)))))

(subsets (list 1))

(subsets (list 1 2 3))

;; Why it works ?
;; The idea of the function is to find all of the subsets for (cdr s) and then
;; create new sequence consisting of all of those subsets as well as appending
;; (list (car s)) to copies of those subsets.
;;
;; For example:
;; input: ()
;; output: (())
;;
;; input: (1)
;; output: (() (1))
;;
;; In the first invocation of subsets s is (1) and rest is (()) and in the let
;; we create the result by appending (()) to ((1)), giving ((), (1)).
;;
;; input: (1 2)
;; output: (() (2) (1) (1 2))
;; In the first invocation of subsets s i (1 2) and rest is (() (2)). When we
;; append (list (car s)) to () and (2) we get ((1) (1 2)) which we append to (()
;; (2)) to get the result.

