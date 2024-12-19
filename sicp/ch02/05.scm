;; Exercise 2.5. Show that we can represent pairs of nonnegative integers using
;; only numbers and arithmetic operations if we represent the pair a and b as
;; the integer that is the product 2^a3^b. Give the corresponding definitions of
;; the procedures cons, car, and cdr.

(define (remove-factor n factor)
  (if (= (remainder n factor) 0)
      (remove-factor (/ n factor) factor)
      n))

(define (log3 n)
  (/ (log n) (log 3)))

(define (cons_ a b)
  (* (expt 2 a) (expt 3 b)))

(define (car_ z)
  (log2 (remove-factor z 3)))

(define (cdr_ z)
  (log3 (remove-factor z 2)))


(car_ (cons_ 5 3))
(cdr_ (cons_ 5 3))

(car_ (cons_ 0 1))
(cdr_ (cons_ 0 1))

(car_ (cons_ 1 0))
(cdr_ (cons_ 1 0))

(car_ (cons_ 101 299))
(cdr_ (cons_ 101 299))
