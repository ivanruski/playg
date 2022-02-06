;; Exercise 1.27. Demonstrate that the Carmichael numbers listed in footnote 47
;; really do fool the Fermat test. That is, write a procedure that takes an integer
;; n and tests whether an is congruent to a modulo n for every a<n, and try your
;; procedure on the given Carmichael numbers.

(define (expmod a exp n)
  (cond ((= exp 0)
         (remainder 1 n))
        ((even? exp)
         (remainder (square (expmod a (/ exp 2) n))
                    n))
        (else (remainder (* (expmod a (- exp 1) n)
                            a)
                         n))))

(define (fermat-test n)
  (define (try-it a)
    (if (= a n)
        #t
        (and (= (expmod a n n) a)
             (try-it (+ a 1)))))
  (try-it 1))

(fermat-test 561)
(fermat-test 1105)
(fermat-test 1729)
(fermat-test 2465)
(fermat-test 2821)
(fermat-test 6601)

;; actually prime
(fermat-test 1009)
