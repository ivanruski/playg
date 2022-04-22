;; Exercise 2.1. Define a better version of make-rat that handles both positive
;; and negative arguments. Make-rat should normalize the sign so that if the
;; rational number is positive, both the numerator and denominator are positive,
;; and if the rational number is negative, only the numberator is negative.

(define (gcd a b)
  (if (= b 0)
      a
      (gcd b (remainder a b))))

;; this version allows for 0 denom
(define (make-rat n d)
  (define (rat-positive? n d)
    (or (and (>= n 0) (>= d 0))
        (and (< n 0) (< d 0))))
  (let ((abs-n (abs n))
        (abs-d (abs d))
        (g (abs (gcd n d))))
    ;; When n = 0, return (0 . 0) so that operations on rat numss don't fail
    (cond ((= n 0) (cons 0 0)) ;; return 0.0 
          ((= d 0) (error "denominator is zero"))
          ((rat-positive? n d)
           (cons (/ abs-n g)
                 (/ abs-d g)))
          (else (cons (/ (- abs-n) g)
                      (/ abs-d g))))))

(make-rat 20 4)
(make-rat -20 4)
(make-rat 20 -4)
(make-rat -20 -4)

(make-rat 0 5)
(make-rat 5 0)
