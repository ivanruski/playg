;; Exercise 2.90. Suppose we want to have a polynomial system that is efficient
;; for both sparse and dense polynomials. One way to do this is to allow both
;; kinds of term-list representations in our system. The situation is analogous
;; to the complex-number example of section 2.4, where we allowed both
;; rectangular and polar representations. To do this we must distinguish
;; different types of term lists and make the operations on term lists
;; generic. Redesign the polynomial system to implement this
;; generalization. This is a major effort, not a local change.

;; As part of this exercise dense-polynomial package was defined, the original
;; polynomial-package was renamed to sparse-polynomial-package and a new
;; polynomial package was created. All of the changes are in generic-arithmetic
;; file.

;; - [x] make dense poly
;; - [x] make sparse poly
;; - [x] mul-terms for dense-polys requires more changes
;; - [x] add
;; - [x] sub
;; - [x] negate
;; - [x] =zero?
;; - [x] parent-type
;; - [ ] make the operations on term lists generic
;; - [ ] cross type(sparse/dense) operations

;; dense-poly examples
(define dp1 (make-dense-polynomial 'x '(1 2 0 3 -2 -5)))
(define dp2 (make-dense-polynomial 'x '(2 0 3 -2 -5)))
(define dp3 (make-dense-polynomial 'x '(8)))
(define dp4 (make-dense-polynomial 'x '(2 0 2 0 2 0 2)))
(define dp5 (make-dense-polynomial 'x '(3 0 3 0 3 0 3)))
(define dp6 (make-dense-polynomial 'x (list 3 (make-rational 3 5))))

;; add
(add dp1 dp2)
(add dp1 dp4)
(add dp3 dp6)

;; mul
(mul dp1 dp2)
(mul dp1 dp3)
(mul dp4 dp5)

;; negate
(negate dp1)
(negate dp5)

;; sub
(sub dp1 dp2)
(sub dp4 dp5)
(sub dp1 dp3)

;; =zero?
(=zero? dp1)
(=zero? (make-dense-polynomial 'x '()))
(=zero? (make-dense-polynomial 'x '(0)))
(=zero? (make-dense-polynomial 'x (list 0 (make-rational 0 1))))

;; polynomial
(define sp1 (make-sparse-polynomial 'x '((3 3) (2 2) (1 1) (0 3))))
