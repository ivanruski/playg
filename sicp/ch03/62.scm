;; Exercise 3.62. Use the results of exercises 3.60 and 3.61 to define a
;; procedure div-series that divides two power series. Div-series should work
;; for any two series, provided that the denominator series begins with a
;; nonzero constant term. (If the denominator has a zero constant term, then
;; div-series should signal an error.) Show how to use div-series together with
;; the result of exercise 3.59 to generate the power series for tangent.

;; load 61.scm
(define (div-series S1 S2)
  (let ((c (stream-car S2)))
    (if (= c 0)
        (error "the denominator can't have 0 constant term -- DIV-SERIES")
        (mul-series S1 (scale-stream (invert-unit-series (scale-stream S2 (/ 1 c)))
                                     (/ 1 c))))))

(define tangent-series (div-series sine-series cosine-series))
;; Value: {0 1 0 1/3 0 2/15 0 17/315 0 62/2835 0 ...}
