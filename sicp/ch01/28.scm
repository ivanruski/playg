;; Exercise 1.28.  One variant of the Fermat test that cannot be fooled is
;; called the Miller-Rabin test (Miller 1976; Rabin 1980). This starts from an
;; alternate form of Fermat's Little Theorem, which states that:
;;
;; if n is a prime number and a is any positive integer less than n,
;; then a raised to the (n - 1)st power is congruent to 1 modulo n.
;; 
;; To test the primality of a number n by the Miller-Rabin test, we pick a random
;; number a<n and raise a to the (n - 1)st power modulo n using the expmod
;; procedure. However, whenever we perform the squaring step in expmod, we check
;; to see if we have discovered a "nontrivial square root of 1 modulo n," that is,
;; a number not equal to 1 or n - 1 whose square is equal to 1 modulo n.
;; 
;; It is possible to prove that if such a nontrivial square root of 1 exists, then
;; n is not prime. It is also possible to prove that if n is an odd number that is
;; not prime, then, for at least half the numbers a<n, computing a^n-1 in this way
;; will reveal a nontrivial square root of 1 modulo n. (This is why the
;; Miller-Rabin test cannot be fooled.) Modify the expmod procedure to signal if it
;; discovers a nontrivial square root of 1, and use this to implement the
;; Miller-Rabin test with a procedure analogous to fermat-test. Check your
;; procedure by testing various known primes and non-primes. Hint: One convenient
;; way to make expmod signal is to have it return 0.

(define (fermat-test n)
  (define (expmod base exp m)
    (cond ((= exp 0) 1)
          ((even? exp)
           (remainder (square (expmod base (/ exp 2) m))
                      m))
          (else
           (remainder (* base (expmod base (- exp 1) m))
                      m))))
  (define (try-it a)
    (= (expmod a n n) a))
  (try-it (+ 1 (random (- n 1)))))

(define (fast-prime? n times)
  (cond ((= times 0) true)
        ((fermat-test n) (fast-prime? n (- times 1)))
        (else false)))

(define (miller-rabin-test n)
  (define (non-trivial-sqrt? x)
    (cond ((or (= x 1) (= x (- n 1))) (square x))
          ((= (remainder (square x) n) 1) 0)
          (else (square x))))
  (define (expmod base exp)
    (cond ((= exp 0) 1)
          ((even? exp)
           (remainder (non-trivial-sqrt? (expmod base (/ exp 2)))
                      n))
          (else
           (remainder (* base (expmod base (- exp 1)))
                      n))))
  (define (try-it a)
    (= (expmod a (- n 1)) 1))
  (try-it (+ 1 (random (- n 1)))))

(define (fast-prime-mr? n times)
  (cond ((= times 0) true)
        ((miller-rabin-test n) (fast-prime-mr? n (- times 1)))
        (else false)))
                      

;; Carmichael's numbers
(fast-prime? 561 100)
(fast-prime-mr? 561 100)

(fast-prime? 1105 100)
(fast-prime-mr? 1105 100)

(fast-prime? 1729 100)
(fast-prime-mr? 1729 100)

(fast-prime? 2465 100)
(fast-prime-mr? 2465 100)

(fast-prime? 2821 100)
(fast-prime-mr? 2821 100)

(fast-prime? 6601 100)
(fast-prime-mr? 6601 100)

 ;; primes from the 23.scm
(fast-prime? 100000007 100)
(fast-prime-mr? 100000007 100)

(fast-prime? 100000037 100)
(fast-prime-mr? 100000037 100)

(fast-prime? 100000039 100)
(fast-prime-mr? 100000039 100)

(fast-prime? 1000000007 100)
(fast-prime-mr? 1000000007 100)

(fast-prime? 1000000009 100)
(fast-prime-mr? 1000000009 100)

(fast-prime? 1000000021 100)
(fast-prime-mr? 1000000021 100)

(fast-prime? 10000000019 100)
(fast-prime-mr? 10000000019 100)

(fast-prime? 10000000033 100)
(fast-prime-mr? 10000000033 100)

(fast-prime? 10000000061 100)
(fast-prime-mr? 10000000061 100)

(fast-prime? 1000000000039 100)
(fast-prime-mr? 1000000000039 100)

;; nontrivial square root
;; 3 is a nontrivial square root of 1 modulo 8
;; (remainder (square 3) 8)
;; https://stackoverflow.com/a/3733401/7364951

