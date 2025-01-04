;; Exercise 2.17. Define a procedure last-pair that returns the list that
;; contains only the last element of a given (nonempty) list:
;;
;; (last-pair (list 23 72 149 34))
;; (34)

(define (last-pair l)
  (if (or (null? l) (= (length l) 1))
      l
      (last-pair (cdr l))))

(last-pair (list 23 72 149 34))
(last-pair (list 23 72))
(last-pair (list 23))
(last-pair '())
