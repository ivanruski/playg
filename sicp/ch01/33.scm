;; Exercise 1.33. You can obtain an even more general version of accumulate
;; (exercise 1.32) by introducing the notion of a filter on the terms to be
;; combined. That is, combine only those terms derived from values in the range
;; that satisfy a specified condition. The resulting filtered-accumulate
;; abstraction takes the same arguments as accumulate, together with an additional
;; predicate of one argument that specifies the filter. Write filtered-accumulate
;; as a procedure. Show how to express the following using filtered-accumulate:
;; 
;; a. the sum of the squares of the prime numbers in the interval a to b (assuming
;; that you have a prime? predicate already written)
;; 
;; b. the product of all the positive integers less than n that are relatively
;; prime to n (i.e., all positive integers i < n such that GCD(i,n) = 1).

(define (filtered-accumulate predicate? combiner null-value term a next b)
  (cond ((> a b) null-value)
        ((predicate? a)
         (combiner (term a)
                   (filtered-accumulate predicate?
                                        combiner
                                        null-value
                                        term
                                        (next a)
                                        next
                                        b)))
        (else (filtered-accumulate predicate?
                                   combiner
                                   null-value
                                   term
                                   (next a)
                                   next
                                   b))))

;; a.

(define (prime? n)
  (define (next a) (+ a 1))
  (define (smallest-divisor n)
    (find-divisor n 2))
  (define (find-divisor n test-divisor)
    (cond ((> (square test-divisor) n) n)
          ((divides? test-divisor n) test-divisor)
          (else (find-divisor n (next test-divisor)))))
  (define (divides? a b)
    (= (remainder b a) 0))
  (= n (smallest-divisor n)))

(define (sum-prime-squares a b)
  (define (inc x) (+ x 1))
  (filtered-accumulate prime? + 0 square a inc b))

;; b.

(define (gcd a b)
  (if (= b 0)
      a
      (gcd b
           (remainder a b))))

(define (prod-rel-primes n)
  (define (inc a) (+ a 1))
  (define (rel-prime? a)
    (= (gcd n a) 1))
  (filtered-accumulate rel-prime? * 1 identity 1 inc (- n 1)))
