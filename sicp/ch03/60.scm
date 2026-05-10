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

(define (mul-series A B)
  (let ((a (stream-car A))
        (b (stream-car B))
        (Ar (stream-cdr A))
        (Br (stream-cdr B)))
  (cons-stream (* a b)
               (add-streams (add-streams (scale-stream Ar b)
                                         (scale-stream Br a))
                            (cons-stream 0
                                         (mul-series Ar Br))))))

(define ss (mul-series sine-series sine-series))
(define cc (mul-series cosine-series cosine-series))

(define sc (add-streams ss cc))
