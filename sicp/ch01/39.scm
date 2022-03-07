;; Exercise 1.39. A continued fraction representation of the tangent function
;; was published in 1770 by the German mathematician J.H. Lambert:
;;
;;
;;                x
;; tanx = ----------------
;;                  x^2
;;         1 - -----------
;;                   x^2
;;             3 - -------
;;
;;                 5 - ...
;;
;; where x is in radians. Define a procedure (tan-cf x k) that computes an
;; approximation to the tangent function based on Lambert's formula. K specifies
;; the number of terms to compute, as in exercise 1.37.

(define (cont-frac-iter n d k)
  (define (iter result i)
    (if (= i 1)
        (/ (n i) result)
        (iter (+ (d (- i 1))
                 (/ (n i) result))
              (- i 1))))
  (iter (d k) k))


(define (tan-cf x k)
  (let ((n (lambda (i)
             (if (= i 1)
                 x
                 (- (square x)))))
        (d (lambda (i) (- (* 2 i) 1))))
    (cont-frac-iter n d k)))
