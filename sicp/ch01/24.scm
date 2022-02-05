;; Exercise 1.24. Modify the timed-prime-test procedure of exercise 1.22 to use
;; fast-prime? (the Fermat method), and test each of the 12 primes you found in
;; that exercise.
;; Since the Fermat test has (log n) growth, how would you expect the time to
;; test primes near 1,000,000 to compare with the time needed to test primes
;; near 1000? Do your data bear this out? Can you explain any discrepancy 
;; you find?

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
  (define rnd (+ (random (- n 1)) 1))
  (= (expmod rnd n n) rnd))

(define (fast-prime? n)
  (define (do-fermat-test count)
    (if (= count 0)
        (fermat-test n)
        (and (fermat-test n)
             (do-fermat-test (- count 1)))))
  (do-fermat-test 10))

(define (timed-prime-test n)
  (newline)
  (display n)
  (start-prime-test n (runtime)))

(define (start-prime-test n start-time)
  (if (fast-prime? n)
      (report-prime (- (runtime) start-time))))

(define (report-prime elapsed-time)
  (display " *** ")
  (display elapsed-time))

;; With logarithmic complexity, doubling the input should increase the time
;; by constant amount.
;; Doubling 1,000 ten times will give us a number around 1,000,000, which means
;; that for the latter fast-prime? should run 10 times slower.
;;
;; My computer prints 0 even for (timed-prime-test 10000000000037)

