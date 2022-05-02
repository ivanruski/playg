;; Exercise 2.9. The width of an interval is half of the difference between its
;; upper and lower bounds. The width is a measure of the uncertainty of the
;; number specified by the interval. For some arithmetic operations the width of
;; the result of combining two intervals is a function only of the widths of the
;; argument intervals, whereas for others the width of the combination is not a
;; function of the widths of the argument intervals. Show that the width of the
;; sum (or difference) of two intervals is a function only of the widths of the
;; intervals being added (or subtracted). Give examples to show that this is not
;; true for multiplication or division.

(define (width interval)
  (/ (- (upper-bound interval)
        (lower-bound interval))
     2.0))

;; i1 = [a, b]
;; i2 = [c, d]
;; width i1 = (b - a) / 2
;; width i2 = (d - c) / 2
;; w1 + w2 = (b - a + d - c) / 2

;; i3 = i1 + i2 = [a + c, b + d]
;; width i3 = (b + d - (a + c)) / 2 = (b - a + d - c) / 2, the same as i1 + i2

;; w1 * w2 = (bd - bc - ad + ac) / 4
;;
;; i4 = i1 * i2 = [a*c, b*d], for a = 1, b = 2, c = 3, d = 4
;; w4 = (b*d - a*c) / 2, not the same as w1 * w1
