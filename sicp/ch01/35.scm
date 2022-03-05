;; Exercise 1.35. Show that the golden ratio (section 1.2.2) is a fixed point of
;; the transformation x -> 1 + 1/x, and use this fact to compute by means of the
;; fixed-point procedure.
;;
;; f(x) = 1 + 1/x
;; To find the fixed point, we need x such that f(x) = x or
;; 1 + 1/x = x (multiplying both sides by x)
;; x + 1 = x^2
;; x^2 - x - 1 = 0
;; x1 = (1 - sqrt(5)) / 2
;; x2 = (1 + sqrt(5)) / 2, that is pfi


;; compute pfi

(define tolerance 0.00001)
(define (fixed-point f first-guess)
  (define (close-enough? v1 v2)
    (< (abs (- v1 v2)) tolerance))
  (define (try guess)
    (let ((next (f guess)))
      (if (close-enough? guess next)
          next
          (try next))))
  (try first-guess))

(define pfi (fixed-point (lambda (x) (+ 1 (/ 1 x))) 1.0))
