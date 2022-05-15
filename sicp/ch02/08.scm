;; Exercise 2.8. Using reasoning analogous to Alyssa's, describe how the
;; difference of two intervals may be computed. Define a corresponding subtraction
;; procedure, called sub-interval.
;; 
;; I didn't know how to susbstract intervals and found out in wikipedia:
;; https://en.wikipedia.org/wiki/Interval_arithmetic#Interval_operators

(define (sub-interval a b)
  (make-interval (- (lower-bound a) (upper-bound b))
                 (- (upper-bound a) (lower-bound b))))

;; The reason we substract the intervals that way is because
;; (lower-bound a) - (upper-bound b) is the smallest number and
;; (upper-bound a) - (lower-bound b) is the largest number. This is true when a
;; is before b, when a is after b and when the intervals are overlapping.
