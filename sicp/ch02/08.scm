;; Exercise 2.8. Using reasoning analogous to Alyssa's, describe how the
;; difference of two intervals may be computed. Define a corresponding subtraction
;; procedure, called sub-interval.
;; 
;; I didn't know how to susbstract intervals and found out in wikipedia:
;; https://en.wikipedia.org/wiki/Interval_arithmetic#Interval_operators

(define (sub-interval a b)
  (make-interval (- (lower-bound a) (upper-bound b))
                 (- (upper-bound a) (lower-bound b))))

;; I think that the reason why we substract intervals this way is so that
;; the result is a valid interval, 
;;
;; (define i1 (make-interval a b)), where a <= b
;; (define i2 (make-interval c d)), where c <= d
;;
;; a - d <= a - c
;; b - d <= b - c
;;
;; since a <= b and a - d <= a - c and a - c < b -c,then b - c > a - d
