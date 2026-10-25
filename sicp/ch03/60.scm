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

;; a power series represented as stream S is equivalent to S = c + xS
;; AxB = (a0 + xAr)*(b0 + xBr)
;; If we expand the multiplication we can implement mul-series in 2 ways:
;;
;; Variant 1:
;; AxB = a0b0 + x(a0Br + b0Ar + xArBr)
(define (mul-series-1 A B)
  ;; we won't want to define Ar & Br in the let because that would force the evaluation of the cdr part
  (let ((a0 (stream-car A))
        (b0 (stream-car B)))
    (cons-stream (* a0 b0)
                 (add-streams (scale-stream (stream-cdr B) a0)
                              (add-streams (scale-stream (stream-cdr A) b0)
                                           ;; We have to prefix with (cons 0 ...)
                                           ;; to account for the x in xArBr
                                           (cons-stream 0 (mul-series-1 (stream-cdr A) (stream-cdr B))))))))

;; Variant 2:
;; AxB = a0b0 + x(a0Br + Ar(b0 + xBr)) =
;;     = a0B0 + x(a0Br + ArB)
(define (mul-series-2 A B)
  ;; we won't want to define Ar & Br in the let because that would force the evaluation of the cdr part
  (let ((a0 (stream-car A))
        (b0 (stream-car B)))
    (cons-stream (* a0 b0)
                 (add-streams (scale-stream (stream-cdr B) a0)
                              (mul-series-2 (stream-cdr A) B)))))

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

(define ss (mul-series-1 sine-series sine-series))
(define cc (mul-series-2 cosine-series cosine-series))

(define sc (add-streams ss cc))
;; Value: {1 0 0 0 0 0 0 0 0 0 0 ...}
