;; Exercise 2.88. Extend the polynomial system to include subtraction of
;; polynomials. (Hint: You may find it helpful to define a generic negation
;; operation.)

;; generic negation for every type is added in generic-arithmetic.scm

;; Test negate
(negate 3)
(negate -3)
(negate 0)

(negate (make-rational 3 2))
(negate (make-rational -3 2))
(negate (make-rational -3 -2))
(negate (make-rational 3 -2))

(negate (make-real 3.5))
(negate (make-real (make-rational 3 5)))

(negate (make-complex-from-real-imag 3 5))
(negate (make-complex-from-mag-ang 3 5))

(negate (make-polynomial 'x '((3 3)
                              (2 2)
                              (1 1)
                              (0 3))))

(negate (make-polynomial 'x '((3 3)
                              (2 -2)
                              (1 1)
                              (0 -3))))

;; after having a negation, sub-poly looks like this:
(put 'sub '(polynomial polynomial)
     (lambda (p1 p2)
       (tag (add-poly p1 (negate-poly p2)))))

(sub (make-polynomial 'x '((3 5)
                           (2 4)))
     (make-polynomial 'x '((2 3))))

(sub (make-polynomial 'x '((3 5)
                           (2 -4)))
     (make-polynomial 'x '((2 3))))

(sub (make-polynomial 'x '((3 5)
                           (2 -4)))
     (make-polynomial 'x '()))

(sub (make-polynomial 'x '())
     (make-polynomial 'x '((3 5)
                           (2 -4))))

(sub (make-polynomial 'x '((0 3)))
     (make-polynomial 'x '((3 5)
                           (2 -4))))
