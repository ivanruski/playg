;; Exercise 2.18. Define a procedure reverse that takes a list as
;; argument and returns a list of the same elements in reverse order:
;; 
;; (reverse (list 1 4 9 16 25))
;; (25 16 9 4 1)


(define (reverse l)
  (if (or (null? l) (= (length l) 1))
      l
      (append (reverse (cdr l))
              (list (car l)))))

(reverse (list 1 2 3 4 5))
(reverse (list 1))
(reverse (list 1 2))
(reverse ())

;; It took me some time to figure out that I have to use append.
;; So I wanted to implement it myself.

(define (append l1 l2)
  (if (null? l1)
      l2
      (cons (car l1)
            (append (cdr l1) l2))))

(append (list 1 2 3 4 5) (list 6 7 8 9))
(append () (list 4 5 6))
(append (list 1 2 3) ())
