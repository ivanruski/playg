;; Exercise 1.23. The smallest-divisor procedure shown at the start of this
;; section does lots of needless testing: After it checks to see if the number is
;; divisible by 2 there is no point in checking to see if it is divisible by any
;; larger even numbers. This suggests that the values used for test-divisor should
;; not be 2, 3, 4, 5, 6, ..., but rather 2, 3, 5, 7, 9, .... To implement this
;; change, define a procedure next that returns 3 if its input is equal to 2 and
;; otherwise returns its input plus 2. Modify the smallest-divisor procedure to
;; use (next test-divisor) instead of (+ test-divisor 1). With timed-prime-test
;; incorporating this modified version of smallest-divisor, run the test for each
;; of the 12 primes found in exercise 1.22. Since this modification halves the
;; number of test steps, you should expect it to run about twice as fast. Is this
;; expectation confirmed? If not, what is the observed ratio of the speeds of the
;; two algorithms, and how do you explain the fact that it is different from 2?


(define (smallest-divisor n)
  (find-divisor n 2))
(define (find-divisor n test-divisor)
  (cond ((> (square test-divisor) n) n)
        ((divides? test-divisor n) test-divisor)
        (else (find-divisor n (next test-divisor)))))
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

;; next function
(define (next n)
  (if (= n 2)
      3
      (+ n 2)))

(timed-prime-test 100000007)
(timed-prime-test 100000037)
(timed-prime-test 100000039)
(timed-prime-test 1000000007)
(timed-prime-test 1000000009)
(timed-prime-test 1000000021)
(timed-prime-test 10000000019)
(timed-prime-test 10000000033)
(timed-prime-test 10000000061)
(timed-prime-test 1000000000039)


;; Note: Executing the function multiple times yields different results, I've
;; tried to pick the most frequent ones out of 10 runs (I've could have averaged
;; the result out of those 10 times, however I didn't do it).
;; 
;; Note: For the largest number, the times are closer to each other, when
;; executed multiple times.
;; 
;; Note: For (+ test-divisor 2), I've modified (smallest-divisor) to start from 3
;; 
;; |               |   (+ test-divisor 1) |  (next test-divisor) |  (+ test-divisor 2) |
;; |---------------+----------------------+----------------------+---------------------|
;; | 100000007     | 0.019999999999999574 | 0.010000000000001563 | 0.00999999999999801 |
;; | 100000037     | 0.019999999999999574 | 0.010000000000001563 | 0.00999999999999801 |
;; | 100000039     | 0.019999999999999574 | 0.010000000000001563 | 0.00999999999999801 |
;; | 1000000007    | 0.03999999999999915  | 0.030000000000001137 | 0.01999999999999602 |
;; | 1000000009    | 0.040000000000000924 | 0.030000000000001137 | 0.01999999999999602 |
;; | 1000000021    | 0.03999999999999915  | 0.030000000000001137 | 0.01999999999999602 |
;; | 10000000019   | 0.08999999999999986  | 0.060000000000002274 | 0.05000000000000426 |
;; | 10000000033   | 0.09000000000000341  | 0.060000000000002274 | 0.05000000000000426 |
;; | 10000000061   | 0.08999999999999986  | 0.060000000000002274 | 0.05000000000000426 |
;; | 1000000000039 | 0.7400000000000002   | 0.45000000000000284  | 0.37000000000000455 |
;; 
;; For some numbers the difference in time is 2 or close to it. However there
;; are cases where the difference is around 1.5.
;; It turns out that calling (next test-divisor) adds some overhead as well.
;; Probably because of the additional function call and checking every time
;; whether the number is 2 or not. 



