;; Exercise 2.88. Extend the polynomial system to include subtraction of
;; polynomials. (Hint: You may find it helpful to define a generic negation
;; operation.)

(load "generic-arithmetic-used-in-2.5.3.scm")

;; test negation
(negate 3)
(negate -3)

(negate (make-rational 21 4))
(negate (make-rational -21 4))
(negate (make-rational -21 -4))
(negate (make-rational 21 -4))

(negate (make-real 3.5))
(negate (make-real -3.5))

(negate (make-complex-from-mag-ang 3 5)) ;; does not work, because I have not implemented it.

(negate (make-complex-from-real-imag 3 5))
(negate (make-complex-from-real-imag 3 -5))
(negate (make-complex-from-real-imag -3 5))
(negate (make-complex-from-real-imag -3 -5))

;; TODO: test subsctraction
