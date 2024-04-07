;; Exercise 2.90. Suppose we want to have a polynomial system that is efficient
;; for both sparse and dense polynomials. One way to do this is to allow both
;; kinds of term-list representations in our system. The situation is analogous
;; to the complex-number example of section 2.4, where we allowed both
;; rectangular and polar representations. To do this we must distinguish
;; different types of term lists and make the operations on term lists
;; generic. Redesign the polynomial system to implement this
;; generalization. This is a major effort, not a local change.

;; As part of this exercise two new packages were defined in
;; generic-arithmetic.scm - sparse-term-list-package and
;; dense-term-list-package.
;;
;; The term-lists implement all of the generic operations: add, mul, sub,
;; negated, raise, project. In this way the polynomial-package has to only call
;; (add term-list-1 term-list-2) and let the generic system do the job.  Also
;; the generic "raise" converts between the two representations i.e. when you
;; try to raise sparse-term-list you get dense-term-list and vice-versa in this
;; way we can add/sub/etc term lists which are with different representations.

;; dense examples
(define dp1 (make-polynomial 'x (make-dense-term-list '(1 2 0 3 -2 -5))))
(define dp2 (make-polynomial 'x (make-dense-term-list '(2 0 3 -2 -5))))
(define dp3 (make-polynomial 'x (make-dense-term-list '(8))))
(define dp4 (make-polynomial 'x (make-dense-term-list '(2 0 2 0 2 0 2))))
(define dp5 (make-polynomial 'x (make-dense-term-list '(3 0 3 0 3 0 3))))
(define dp6 (make-polynomial 'x (make-dense-term-list (list 3 (make-rational 3 5)))))
(define dp7 (make-polynomial 'x (make-dense-term-list '(2 0 2 0 2 2 2))))
(define dp8 (make-polynomial 'x (make-dense-term-list '(3 0 3 0 3 3 3))))

;; add
(add dp1 dp2)
(add dp1 dp4)
(add dp3 dp6)
(add dp1 dp3)

;; negate
(negate dp1)
(negate dp5)
(negate dp6)

;; sub
(sub dp1 dp2)
(sub dp4 dp5)
(sub dp1 dp3)
(sub dp2 dp6)

;; mul
(mul dp1 dp2)
(mul dp1 dp3)
(mul dp4 dp5)
(mul dp7 dp8)

;; =zero?
(=zero? dp1)
(=zero? (make-dense-polynomial 'x '()))
(=zero? (make-dense-polynomial 'x '(0)))
(=zero? (make-dense-polynomial 'x (list 0 (make-rational 0 1))))

;; sparse examples
(define sp1 (make-polynomial 'x (make-sparse-term-list '((5 1) (4 2) (2 3) (1 -2) (0 -5)))))
(define sp2 (make-polynomial 'x (make-sparse-term-list '((4 2) (2 3) (1 -2) (0 -5)))))
(define sp3 (make-polynomial 'x (make-sparse-term-list '((0 8)))))
(define sp4 (make-polynomial 'x (make-sparse-term-list '((6 2) (4 2) (2 2) (0 2)))))
(define sp5 (make-polynomial 'x (make-sparse-term-list '((6 3) (4 3) (2 3) (0 3)))))
(define sp6 (make-polynomial 'x (make-sparse-term-list (list '(1 3) (list 0 (make-rational 3 5))))))
(define sp7 (make-polynomial 'x (make-sparse-term-list '((6 2) (4 2) (2 2) (1 2) (0 2)))))
(define sp8 (make-polynomial 'x (make-sparse-term-list '((6 3) (4 3) (2 3) (1 3) (0 3)))))

;; add
(add sp1 sp2)
(add sp1 sp4)
(add sp3 sp6)
(add sp1 sp3)

;; negate
(negate sp1)
(negate (negate sp1))
(negate sp5)
(negate sp6)

;; sub
(sub sp1 sp2)
(sub sp4 sp5)
(sub sp1 sp3)
(sub sp2 sp6)

;; mul
(mul sp1 sp2)
(mul sp1 sp3)
(mul sp4 sp5)
(mul sp7 sp8)

;; cross representation examples
(add sp1 dp1)
(add dp1 sp1)

(mul sp7 dp8)
(mul dp7 sp8)
