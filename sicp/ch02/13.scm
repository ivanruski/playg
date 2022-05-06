;; Exercise 2.13 Show that under the assumption of small percentage tolerances
;; there is a simple formula for the approximate percentage tolerance of the
;; product of two intervals in terms of the tolerances of the factors. You may
;; simplify the problem by assuming that all numbers are positive.

(define (mul-interval x y)
  (let ((p1 (* (lower-bound x) (lower-bound y)))
        (p2 (* (lower-bound x) (upper-bound y)))
        (p3 (* (upper-bound x) (lower-bound y)))
        (p4 (* (upper-bound x) (upper-bound y))))
    (make-interval (min p1 p2 p3 p4)
                   (max p1 p2 p3 p4))))

(define (make-interval a b) (cons a b))

(define (lower-bound a) (car a))
(define (upper-bound a) (cdr a))

;; After a couple of tries with different small percentage tolerances it can be
;; observed that when the the tolerances are small the tolerance of the product
;; is the sum of the factors

(percent (mul-interval (make-center-percent 100 0.01)
                       (make-center-percent 300 0.01)))
;; ~0.02

(percent (mul-interval (make-center-percent 100 0.02)
                       (make-center-percent 300 0.03)))
;; ~0.05

;; Lets have two intervals defined with center and percent tolerance.
;; A = (Ca, Pa)
;; B = (Cb, Pb)
;;
;; The result C of AxB is:
;; C's lower bound = (Ca - CaPa) x (Cb - CbPb)
;; C's upper bound = (Ca + CaPa) x (Cb + CbPb)
;;
;; When we try to simplify the two bounds we get:
;; C's lower bound = CaCb(1 - (Pb + Pa) + PaPb)
;; C's upper bound = CaCb(1 + (Pb + Pa) + PaPb) ; (Pb + Pa) for better alignment
;;
;; and if PaPb is small enough, it can be neglected.
