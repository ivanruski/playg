;; Exercise 1.22. Most Lisp implementations include a primitive called runtime
;; that returns an integer that specifies the amount of time the system has been
;; running (measured, for example, in microseconds). The following timed-prime-test
;; procedure, when called with an integer n, prints n and checks to see if n is
;; prime. If n is prime, the procedure prints three asterisks followed by the
;; amount of time used in performing the test.

(define (smallest-divisor n)
  (find-divisor n 2))
(define (find-divisor n test-divisor)
  (cond ((> (square test-divisor) n) n)
        ((divides? test-divisor n) test-divisor)
        (else (find-divisor n (+ test-divisor 1)))))
(define (divides? a b)
  (= (remainder b a) 0))

(define (prime? n)
  (= n (smallest-divisor n)))

(define (timed-prime-test n)
  (newline)
  (display n)
  (start-prime-test n (runtime)))
(define (start-prime-test n start-time)
  (if (prime? n)
      (report-prime (- (runtime) start-time))))
(define (report-prime elapsed-time)
  (display " *** ")
  (display elapsed-time))

;; Using this procedure, write a procedure search-for-primes that checks the
;; primality of consecutive odd integers in a specified range. Use your procedure
;; to find the three smallest primes larger than 1000; larger than 10,000; larger
;; than 100,000; larger than 1,000,000. Note the time needed to test each prime.
;; Since the testing algorithm has order of growth of sqrt(n), you should expect
;; that testing for primes around 10,000 should take about sqrt(10) times as long
;; as testing for primes around 1000. Do your timing data bear this out? How well
;; do the data for 100,000 and 1,000,000 support the sqrt(n) prediction? Is your
;; result compatible with the notion that programs on your machine run in time
;; proportional to the number of steps required for the computation?

;; I find writing search-for-primes using timed-prime-test a bit odd.
;; I've implemented it using just prime? functions and I am returning
;; list of the primes within the given range

(define (search-for-primes from to)
  (define (odd-iter n)
    (cond ((>= n to) '())
          ((prime? n) (cons n (odd-iter (+ n 2))))
          (else (odd-iter (+ n 2)))))
  (if (< from to)
      (if (even? from)
          (odd-iter (+ from 1))
          (odd-iter from))
      '()))

(define (take list n)
  (if (<= n 0)
      '()
      (cons (car list)
            (take (cdr list) (- n 1)))))

;; Three smallest primes larger than 1000; 10 000; 100 000; 1 000 000
;; (take (search-for-primes 1000 1500) 3)
;; (take (search-for-primes 10000 10500) 3)
;; (take (search-for-primes 100000 100500) 3)
;; (take (search-for-primes 1000000 1000500) 3)

;; I had to run timed-prime-test with bigger numbers because it's 2022
;; (timed-prime-test 100000007)
;; 100000007 *** .00999999999999801
;;
;; with 100 times bigger 
;; (timed-prime-test 10000000019)
;; 10000000019 *** .09000000000000341
;;
;; with 10 000 times bigger
;; (timed-prime-test 1000000000039)
;; 1000000000039 *** .6900000000000048
;; 
;; I expect that the difference in time between each test would grow with
;; around 10 times (becuase I increase the input nums multiplying by 100).
;; The results are close to my expectations, especially the difference in time
;; between the first and the second.
