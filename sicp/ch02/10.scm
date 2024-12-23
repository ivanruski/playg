;; Exercise 2.10. Ben Bitdiddle, an expert systems programmer, looks over
;; Alyssa's shoulder and comments that it is not clear what it means to divide
;; by an interval that spans zero. Modify Alyssa's code to check for this
;; condition and to signal an error if it occurs.

;; We have to check this because the reciprocal of an interval that spans zero
;; is not a valid interval, because the upper bound will be less than the lower
;; bound.

(define (make-interval a b) (cons a b))
(define (lower-bound interval) (car interval))
(define (upper-bound interval) (cdr interval))

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

(div-interval (make-interval 1 5) (make-interval 5 10))
(div-interval (make-interval -1 5) (make-interval 5 10))
(div-interval (make-interval 1 5) (make-interval -5 10))
(div-interval (make-interval 1 5) (make-interval 0 10))
