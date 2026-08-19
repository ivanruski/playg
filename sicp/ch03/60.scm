;; Exercise 3.60. With power series represented as streams of coefficients as in
;; exercise 3.59, adding series is implemented by add-streams. Complete the
;; definition of the following procedure for multiplying series:
;;
;; (define (mul-series s1 s2)
;;   (cons-stream <??> (add-streams <??> <??>)))
;;
;; You can test your procedure by verifying that sin^2 x + cos^2 x = 1, using
;; the series from exercise 3.59.

(define (add-streams s1 s2)
  (stream-map + s1 s2))

(define (scale-stream s factor)
  (stream-map (lambda (x) (* x factor)) s))

(define (mul-series s1 s2)
  (cons-stream (* (stream-car s1)
                  (stream-car s2))
               (add-streams (stream-map (lambda (x) (* x (stream-car s1))) (stream-cdr s2))
                            (mul-series (stream-cdr s1) s2))))

;;;; test
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

;; It took me A LOT of time to figure this out
(define cosine-series
  (cons-stream 1 (scale-stream (integrate-series sine-series)
                               -1)))

(define sine-series
  (cons-stream 0 (integrate-series cosine-series)))

(define ss (mul-series sine-series sine-series))
(define cc (mul-series cosine-series cosine-series))

(define sc (add-streams ss cc))
;; Value: {1 0 0 0 0 0 0 0 0 0 0 ...}
