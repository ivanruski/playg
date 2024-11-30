;; Exercise 2.1.  Define a better version of make-rat that handles both positive
;; and negative arguments. Make-rat should normalize the sign so that if the
;; rational number is positive, both the numerator and denominator are positive,
;; and if the rational number is negative, only the numerator is negative.

(define (make-rat n d)
  (let ((g (gcd n d)))
    (cond ((= d 0) (error "denominator can not be zero"))
          ((and (< n 0) (< d 0)) (cons (/ (abs n) g)
                                       (/ (abs d) g)))
          ((or (< n 0) (< d 0)) (cons (/ (- (abs n)) g)
                                      (/ (abs d) g)))
          (else (cons (/ n g)
                      (/ d g))))))

(make-rat 5 3)
(make-rat -5 3)
(make-rat 5 -3)
(make-rat -5 -3)
(make-rat -5 0)
