;; Exercise 2.17. Define a procedure last-pair that returns the list
;; that contains only the last element of a given (nonempty) list:
;; 
;; (last-pair (list 23 72 149 34))
;; (34)


(define (last-pair l)
  (if (or (null? l) (null? (cdr l)))
      l
      (last-pair (cdr l))))

;; or if we want to return an error when the input is null

(define (last-pair list)
  (cond ((null? list) (error "passed object is nil"))
        ((= (length list) 1) list)
        (else (last-pair (cdr list)))))


(last-pair (list 23 72 149 34))
(last-pair (list 1 2))
(last-pair (list 1))
(last-pair ())

