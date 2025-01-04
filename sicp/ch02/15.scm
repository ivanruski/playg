;; Exercise 2.15. Eva Lu Ator, another user, has also noticed the different
;; intervals computed by different but algebraically equivalent expressions.
;; She says that a formula to compute with intervals using Alyssa's system will
;; produce tighter error bounds if it can be written in such a form that no
;; variable that represents an uncertain number is repeated. Thus, she says,
;; par2 is a ``better'' program for parallel resistances than par1. Is she
;; right? Why?

(define A (make-center-percent 100 0.1))
(define B (make-center-percent 200 0.1))
(define C (make-interval 100 200))
(define ONE (make-interval 1 1))

(par1 A B)
(par2 A B)

(par1 A C)
(par2 A C)

(par1 B C)
(par2 B C)

;; Using my examples from the previous exercise(intervals with positive bounds
;; only) Eva appears to be right. par2 computes tighter bounds. Exapnding both
;; formulas 1 and 2 I get the following:
;;
;; L = lower bound
;; U = upper bound
;; 
;; 1) (R1 * R2) / (R1 + R2) = interval with lower bound (L1 * L2) / (U1 + U2)
;; and upper bound (U1 * U2) / (L1 + L2).
;; If we compare numerators and denominators of the lower and upper bound
;; numer: L1 * L2 < U1 * U2 and denom: U1 + U2 > L1 + L2 we see that for the
;; lower bound we divide smaller number into larger and for the uppoer we
;; divide larger into smaller and I think that this is the reason why the intervals
;; are wider compared to the second formula.
;;
;; 2) 1 / (1/R1 + 1/R2) = interval with lower bound (L1 * L2) / (L1 + L2)
;; and upper bound (U1 * U2) / (U1 + U2). In this case the relationship between the
;; numerators and denominators of the bounds is consistent leading to tighter bounds.
;;
;; As for "no variable that represents an uncertain number is repeated, yielding
;; a better results": I think the reason behind this statement is that each time
;; we multiply/divide intervals we widen the range.

;; code from 2.14

(define (par1 r1 r2)
  (div-interval (mul-interval r1 r2)
                (add-interval r1 r2)))

(define (par2 r1 r2)
  (let ((one (make-interval 1 1))) 
    (div-interval one
                  (add-interval (div-interval one r1)
                                (div-interval one r2)))))

(define (reciprocal x)
  (make-interval (/ 1.0 (upper-bound x))
                 (/ 1.0 (lower-bound x))))

(define (make-interval a b) (cons a b))
(define (lower-bound interval) (car interval))
(define (upper-bound interval) (cdr interval))

(define (make-center-width c w)
  (make-interval (- c w) (+ c w)))

(define (center i)
  (/ (+ (lower-bound i) (upper-bound i)) 2))

(define (width i)
  (/ (- (upper-bound i) (lower-bound i)) 2))

(define (make-center-percent center tolerance)
  (make-center-width center (* center tolerance)))

(define (percent interval)
  (/ (width interval) (center interval)))

(define (div-interval x y)
  (define (spans-zero? interval)
    (let ((l (lower-bound interval))
          (u (upper-bound interval)))
      (or (= l 0)
          (= u 0)
          (and (negative? l)
               (positive? u)))))
  (if (or (spans-zero? x) (spans-zero? y))
      (error "Dividing interval that spans zero is not allowed.")
      (mul-interval x
                    (make-interval (/ 1.0 (upper-bound y))
                                   (/ 1.0 (lower-bound y))))))

(define (add-interval x y)
  (make-interval (+ (lower-bound x) (lower-bound y))
                 (+ (upper-bound x) (upper-bound y))))

(define (mul-interval x y)
  (let ((p1 (* (lower-bound x) (lower-bound y)))
        (p2 (* (lower-bound x) (upper-bound y)))
        (p3 (* (upper-bound x) (lower-bound y)))
        (p4 (* (upper-bound x) (upper-bound y))))
    (make-interval (min p1 p2 p3 p4)
                   (max p1 p2 p3 p4))))
