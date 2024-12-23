;; Exercise 2.9. The width of an interval is half of the difference between its
;; upper and lower bounds. The width is a measure of the uncertainty of the
;; number specified by the interval. For some arithmetic operations the width of
;; the result of combining two intervals is a function only of the widths of the
;; argument intervals, whereas for others the width of the combination is not a
;; function of the widths of the argument intervals. Show that the width of the
;; sum (or difference) of two intervals is a function only of the widths of the
;; intervals being added (or subtracted). Give examples to show that this is not
;; true for multiplication or division.


(define (make-interval a b) (cons a b))
(define (lower-bound interval) (car interval))
(define (upper-bound interval) (cdr interval))

;; 1. The width of an interval is half of the difference between its upper and lower bounds

(define (interval-width interval)
  (/ (- (upper-bound interval)
        (lower-bound interval))
     2.))

;; For some arithmetic operations the width of the result of combining two
;; intervals is a function only of the widths of the argument intervals, whereas
;; for others the width of the combination is not a function of the widths of
;; the argument intervals.
;; 
;; Show that the width of the sum (or difference) of two intervals is a
;; function only of the widths of the intervals being added (or
;; subtracted). Give examples to show that this is not true for multiplication
;; or division.

(define (add-interval x y)
  (make-interval (+ (lower-bound x) (lower-bound y))
                 (+ (upper-bound x) (upper-bound y))))

(define x (make-interval 10 20))
(define y (make-interval 4 50))

(interval-width x)
(interval-width y)

(+ (interval-width x) (interval-width y))
(interval-width (add-interval x y))

;; We can show that the width is a function of the intervals being added like so:

;; I1 = l1, u1, I1 width = (u1 - l1) / 2
;; I2 = l2, u2, I2 width = (u2 - l2) / 2
;; I3 = I1 + I2
;;
;; If we expand we'll see that I3 witdh is the same as I1 width + I2 width.
;;
;; I think that this is true for the sum/diff for intervals because when we sum/diff
;; we sum/diff lower-bound with lower-bound and upper-bound with upper-bound.
;;
;; If we use the same logic for product, we'll see that we instead of adding interval
;; bounds we are multiplying them and the I1 width * I width is no longer the same as
;; I3 width.

(define (mul-interval x y)
  (let ((p1 (* (lower-bound x) (lower-bound y)))
        (p2 (* (lower-bound x) (upper-bound y)))
        (p3 (* (upper-bound x) (lower-bound y)))
        (p4 (* (upper-bound x) (upper-bound y))))
    (make-interval (min p1 p2 p3 p4)
                   (max p1 p2 p3 p4))))

(mul-interval x y)
(interval-width (mul-interval x y))
(* (interval-width x) (interval-width y))
