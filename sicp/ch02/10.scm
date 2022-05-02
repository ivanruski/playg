;; Exercise 2.10. Ben Bitdiddle, an expert systems programmer, looks over
;; Alyssa's shoulder and comments that it is not clear what it means to divide
;; by an interval that spans zero. Modify Alyssa's code to check for this
;; condition and to signal an error if it occurs.

(define (div-interval x y)
  (define (spans-zero? interval)
    (and (<= (lower-bound interval) 0)
         (<= 0 (upper-bound interval))))
  (if (spans-zero? y)
      (error "can't divide by an interval spanning zero" y)
      (mul-interval x
                    (make-interval (/ 1.0 (upper-bound y))
                                   (/ 1.0 (lower-bound y))))))
