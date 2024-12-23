;; Exercise 2.13. Show that under the assumption of small percentage tolerances
;; there is a simple formula for the approximate percentage tolerance of the
;; product of two intervals in terms of the tolerances of the factors. You may
;; simplify the problem by assuming that all numbers are positive.

;; I won't expand the whole showcase, but if we start from:
;;
;; I1 with Center(C1) and Percentage tolerance(P1) we have the interval:
;; lower bound = C1 - (C1 x P1)
;; upper bound = C1 + (C1 x P1)
;;
;; I2 with Center(C2) and Percentage tolerance(P2) we have the interval:
;; lower bound = C2 - (C2 x P2)
;; upper bound = C2 + (C2 x P2)
;;
;; If we multiply them we'll get the interval:
;; lower bound = C1C2(1 - P2 - P1 + P1P2) (1)
;; upper bound = C1C2(1 + P2 + P1 + P1P2) (2)
;;
;; If we try to calculate the percentage tolerance of the new interval which
;; is width/center or (upper bound - lower bound) / (upper bound + lower bound)
;; and exapnd this with (1) and (2) and then simplify, we would get that the
;; percentage is equal to (P1 + P2) / (1 + P1P2).
;;
;; For small P1 and P2 that would mean we can get rid of the denominator
;; and the simple formula would be (P1 + P2)

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

(define (mul-interval x y)
  (let ((p1 (* (lower-bound x) (lower-bound y)))
        (p2 (* (lower-bound x) (upper-bound y)))
        (p3 (* (upper-bound x) (lower-bound y)))
        (p4 (* (upper-bound x) (upper-bound y))))
    (make-interval (min p1 p2 p3 p4)
                   (max p1 p2 p3 p4))))

(define i1 (make-center-percent 100 0.00004))
(define i2 (make-center-percent 200 0.00006))

(percent (mul-interval i1 i2))
(+ (percent i1) (percent i2))
