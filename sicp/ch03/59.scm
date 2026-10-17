;; Exercise 3.59 Section 2.5.3 we saw how to implement a polynomial arithmetic
;; system representing polynomials as lists of terms. In a similar way, we can
;; work with power series, such as
;;
;;                  x²   x³     x⁴
;;     eⁿ = 1 + x + ─ + ─── + ───── + …
;;                  2   3·2   4·3·2
;;
;;              x²    x⁴
;;   cosx = 1 - ─ + ───── - …
;;              2   4·3·2
;;
;;               x³     x⁵
;;   sinx = x - ─── + ─────── - …
;;              3·2   5·4·3·2
;;
;; represented as infinite streams. We will represent the series a₀ + a₁x +
;; a₂x² + a₃x³ + … as the stream whose elements are the coefficients a₀, a₁,
;; a₂, a₃, ….
;;
;;
;; a. The integral of the series a₀ + a₁x + a₂x² + a₃x³ + … is the series
;;
;;             1        1        1
;;   c + a₀x + ─ a₁x² + ─ a₂x³ + ─ a₃x⁴ + …
;;             2        3        4
;;
;;
;; where c is any constant. Define a procedure integrate-series that takes as
;; input a stream a₀, a₁, a₂, ... representing a power series and returns the
;; stream a₀, 1/2*a₁, 1/3*a₂, ... of coefficients of the non-constant terms of the
;; integral series. (Since the result has no constant term, it doesn't
;; represent a power series; when we use integrate-series, we will cons on the
;; appropriate constant.)
;;
;; b. The function x -> eⁿ is its own derivative. This implies that eⁿ and the
;; ingral of eⁿ are the same series, except for the constant term, which is
;; e⁰ = 1. Accordingly, we can generate the series for eⁿ as
;;
;;   (define exp-series
;;     (cons-stream 1 (integrate-series exp-series)))
;;
;; Show how to generate the series for sine and cosine starting from the facts
;; that the given derivative of sine is cosine and the derivative of cosine is
;; the negative of sine:
;;
;;   (define cosine-series
;;     (cons-stream 1 <??>))
;;
;;   (define sine-series
;;     (cons-stream 0 <??>))

(define (integers-starting-from n)
  (cons-stream n (integers-starting-from (+ n 1))))

(define integers (integers-starting-from 1))

;; for reference, not the actual implementation
(define (stream-map fn s1 s2)
  (cons-stream (fn (stream-car s1) (stream-car s2))
               (stream-map fn (stream-cdr s1) (stream-cdr s2))))

(define (integrate-series S)
  (stream-map / S integers))

;; It took me A LOT of time to figure this out
(define cosine-series
  (cons-stream 1 (integrate-series (stream-map - sine-series))))

(define sine-series
  (cons-stream 0 (integrate-series cosine-series)))

;; sine-series
;; 0 - 0
;; 1 - 1      = (car cos) / 1
;; 2 - 0      = (stream-ref cos 1) / 2
;; 3 - -1/6   = (stream-ref cos 2) / 3
;; 4 - 0      = (stream-ref cos 3) / 4
;; 5 - 1/120  = (stream-ref cos 4) / 5
;; ...

;; cos-series
;; 0 - 1
;; 1 - 0     = (- (car sin)) / 1
;; 2 - -1/2  = (- (stream-ref sin 1)) / 2
;; 3 - 0     = (- (stream-ref sin 2)) / 3
;; 4 - 1/24  = (- (stream-ref sin 3)) / 4
;; ...
