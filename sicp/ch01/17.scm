;; Exercise 1.17.  The exponentiation algorithms in this section are based on
;; performing exponentiation by means of repeated multiplication. In a similar
;; way, one can perform integer multiplication by means of repeated addition.
;; The following multiplication procedure (in which it is assumed that our
;; language can only add, not multiply) is analogous to the expt procedure:

(define (* a b)
  (if (= b 0)
      0
      (+ a (* a (- b 1)))))

;; This algorithm takes a number of steps that is linear in b. Now suppose we
;; include, together with addition, operations double, which doubles an integer,
;; and halve, which divides an (even) integer by 2. Using these, design a
;; multiplication procedure analogous to fast-expt that uses a logarithmic number
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

;; logarithmic multiplication
(define (fast-m a b)
  (cond ((= b 0) 0)
        ((even b) (fast-m (double a)
                          (halve b)))
        (else (+ a (fast-m a (- b 1))))))

;; Simple implementation to work for negative nums
(define (my-* a b)
  (cond ((and (< a 0) (< b 0)) (fast-m (abs a)
                                       (abs b)))
        ((or (< a 0) (< b 0)) (- (fast-m (abs a)
                                         (abs b))))
        (else (fast-m (abs a)
                      (abs b)))))
