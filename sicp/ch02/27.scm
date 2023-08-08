;; Exercise 2.27. Modify your reverse procedure of exercise 2.18 to
;; produce a deep-reverse procedure that takes a list as argument and
;; returns as its value the list with its elements reversed and with all
;; sublists deep-reversed as well.
 
(define x (list (list 1 2) (list 3 4)))
(define y (list 1 (list 2 3) 4 (list 5 6)))
(define z (list 1 (list 2 3) 4 (list 5 6 (list 7 (list 8 9)))))

(reverse x)
(reverse y)
(reverse z)

(define (deep-reverse l)
  (cond ((null? l) l)
        ((list? (car l))
         (append (deep-reverse (cdr l))
                 (list (deep-reverse (car l)))))
        (else (append (deep-reverse (cdr l))
                      (list (car l))))))

(deep-reverse x)
(deep-reverse y)
(deep-reverse z)
