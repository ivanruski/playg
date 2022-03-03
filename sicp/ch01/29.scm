;; Exercise 1.29 Simpson's Rule is a more accurate method of numerical
;; integration than the method illustrated above. Using Simpson's Rule, the
;; integral of a function f between a and b is approximated as:
;;
;; h
;; ─(y₀ + 4y₁ + 2y₂ + 4y₃ + 2y₄ + ... + 2yₙ₋₂ + 4yₙ₋₁ + y)
;; 3
;;
;; where h = (b - a)/n, for some even integer n, and yₖ = f(a + kh). (Increasing
;; n increases the accuracy of the approximation.) Define a procedure that takes
;; as arguments f, a, b and n and returns the value of the integral, computed
;; using Simpson's Rule. Use your procedure to integrate cube between 0 and 1
;; (with n = 100 and n = 1000), and compare the results to those of the integral
;; procedure shown above.

(define (sum term a next b)
  (if (> a b)
      0
      (+ (term a)
         (sum term (next a) next b))))

(define (inc n) (+ n 1))

(define (cube x) (* x x x))

(define (integral f a b dx)
  (define (add-dx x) (+ x dx))
  (* (sum f (+ a (/ dx 2.0)) add-dx b)
     dx))

(define (integral-simpson f a b n)
  (define h (/ (- b a) n))
  (define (yk k)
    (f (+ a
          (* k h))))
  (define (term k)
    (cond ((= k 0) (yk k))
          ((= k n) (yk n))
          ((even? k) (* 2 (yk k)))
          (else (* 4 (yk k)))))
  (* (/ h 3)
     (sum term 0 inc n)))

(integral cube 0 1 0.01)
(integral-simpson cube 0 1 100.0)

(integral cube 0 1 0.001)
(integral-simpson cube 0 1 1000.0)


;; In both cases the lesser dx/n is the result is more accurate
;; |                  |             0.1/10 |           0.01/100 |        0.001/1000 |
;; |------------------+--------------------+--------------------+-------------------|
;; | integral         | .24874999999999994 | .24998750000000042 |  .249999875000001 |
;; | integral-simpson |                .25 | .24999999999999992 | .2500000000000003 |
