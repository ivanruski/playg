;; Exercise 2.18. Define a procedure reverse that takes a list as argument and
;; returns a list of the same elements in reverse order:
;;
;; (reverse (list 1 4 9 16 25))
;; (25 16 9 4 1)

(define (reverse l)
  (if (null? l)
      l
      (append (reverse (cdr l))
              (list (car l)))))

(reverse (list 1 4 9 16 25))
(reverse (list 1))
(reverse '())
