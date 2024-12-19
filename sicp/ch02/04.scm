;; Exercise 2.4. Here is an alternative procedural representation of pairs. For
;; this representation, verify that (car (cons x y)) yields x for any objects x
;; and y.

(define (cons_ x y)
  (lambda (m) (m x y)))

(define (car_ z)
  (z (lambda (p q) p)))

(car_ (cons_ 5 3))
(car_ (cons_ 5 (cons_ 8 8)))
(car_ (car_ (cons_ (cons_ 1 2) 5)))

;; What is the corresponding definition of cdr? (Hint: To verify that this
;; works, make use of the substitution model of section 1.1.5.)

(define (cdr_ z)
  (z (lambda (p q) q)))

(cdr_ (cons_ 5 3))
(cdr_ (cons_ (cons_ 1 2) 5))
(car_ (cdr_ (cons_ 5 (cons_ 7 8))))

;; Using the substition model
(cons_ 3 5) ;; is (lambda (m) (m 3 5))
(cdr_ (lambda (m) (m 3 5)))
((lambda (m) (m 3 5)) (lambda (p q) q))
((lambda (p q) q) 3 5)
