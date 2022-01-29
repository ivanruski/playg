;; Exercise 1.18.  Using the results of exercises 1.16 and 1.17, devise a
;; procedure that generates an iterative process for multiplying two integers
;; in terms of adding, doubling, and halving and uses a logarithmic number
;; of steps.

(define (double x) (+ x x))

;; won't work for odd nums
(define (halve x)
  (define (find-mid guess)
    (if (= (+ guess guess) (abs x))
        guess
        (find-mid (+ guess 1))))
  (cond ((= x 0) 0)
        ((< x 0) (- (find-mid 1)))
        (else (find-mid 1))))

(define (even n) (= (remainder n 2) 0))

(define (fast-m-iter k a b)
  (cond ((= b 0) k)
        ((even b) (fast-m-iter k (double a) (halve b)))
        (else (fast-m-iter (+ k a) a (- b 1)))))
