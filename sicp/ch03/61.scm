;; Exercise 3.61. Let S be a power series (exercise 3.59) whose constant term is 1. Suppose we
;; want to find the power series 1/S, that is, the series X such that SX = 1.
;; Write S = 1 + Sᵣ where Sᵣ is the part of S after the constant term. Then we
;; can solve for X as follows:
;;
;;          S·X = 1
;;   (1 + Sᵣ)·X = 1
;;     X + Sᵣ·X = 1
;;            X = 1 - Sᵣ·X
;;
;; In other words, X is the power series whose constant term is 1 and whose
;; higher-order terms are given by the genative of Sᵣ times X. Use this idea to
;; write a procedure invert-unit-series that computes 1/S for a power series S
;; with constant term 1. You will need to use mul-series from exercise 3.60.

(define (negate-stream S)
  (stream-map (lambda (x) (- x)) S))

(define (invert-unit-series S)
  (define X (cons-stream 1
                         (negate-stream
                          (mul-series (stream-cdr S)
                                      X))))
  X)

;; from 3.60
(define (add-streams s1 s2)
  (stream-map + s1 s2))

(define (scale-stream s factor)
  (stream-map (lambda (x) (* x factor)) s))

(define (mul-series s1 s2)
  (cons-stream (* (stream-car s1)
                  (stream-car s2))
               (add-streams (stream-map (lambda (x) (* x (stream-car s1))) (stream-cdr s2))
                            (mul-series (stream-cdr s1) s2))))

;; from 3.59
(define (integers-starting-from n)
  (cons-stream n (integers-starting-from (+ n 1))))

(define (integrate-series series)
  (stream-map (lambda (a n) (/ a n))
              series
              (integers-starting-from 1)))

(define (scale-stream stream factor)
  (stream-map (lambda (x) (* x factor)) stream))

(define exp-series
  (cons-stream 1 (integrate-series exp-series)))

;;;; tests
;; 
(define sine-series
  (cons-stream 0 (integrate-series cosine-series)))

(define cosine-series
  (cons-stream 1 (scale-stream (integrate-series sine-series)
                               -1)))

(define t1 (mul-series cosine-series (invert-unit-series cosine-series)))
;; Value: {1 0 0 0 0 0 0 0 0 0 0 ...}

(define i1 (cons-stream 1
                        (cons-stream 6
                                     (cons-stream 12
                                                  (cons-stream 20
                                                               (cons-stream 32 the-empty-stream))))))

(define t2 (mul-series i1 (invert-unit-series i1)))
;; Value: {1 0 0 0 0 ...}
