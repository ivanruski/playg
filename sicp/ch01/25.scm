;; Exercise 1.25. Alyssa P. Hacker complains that we went to a lot of extra
;; work in writing expmod. After all, she says, since we already know how to
;; compute exponentials, we could have simply written

(define (expmod-a base exp m)
  (remainder (fast-expt-iter 1 base exp) m))

(define (fast-expt-iter a base exp)
  (cond ((= exp 0) a)
        ((even? exp)
         (fast-expt-iter a (square base) (/ exp 2)))
        (else
         (fast-expt-iter (* a base) base (- exp 1)))))

;; Is she correct? Would this procedure serve as well for our fast prime
;; tester? Explain.

;; She is not correct because with her approach first we are rising the
;; given number to the given exponent and than checking what's the remainder
;; of a^n mod n. Which for very large powers would cause the program to OOM
;; or freeze (at least from my observations), because for example 2^82,589,933
;; has 24 million digits. The arithmetic operations related to so large
;; numbers are carried out on a software level instead of on a hardware level
;; which slows down the procedure.
;; 
;; Whereas with our version of expmod we are not dealing with such a numbers.
;; With our version the biggest number that we are working with should be
;; at most (82,589,933 - 1)^2, because we are never rising the base to the given
;; power because we use the fact that (x*y) mod n = ((x mod n) * (y mod n)) mod n
;; and (x mod n) and (y mod n) couldn't be larger that n.
